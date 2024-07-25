provider "aws" {
  region = "eu-central-1"
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Create public subnets
resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = element(["eu-central-1a", "eu-central-1b"], count.index)
  map_public_ip_on_launch = true
}

# Create an internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# Create a route table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

# Associate the route table with the subnets
resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.main.id
}

# Security group to allow HTTP traffic
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    ignore_changes = all
  }
}

# ECS cluster
resource "aws_ecs_cluster" "main" {
  name = "my-cluster"
}

# Task definition
resource "aws_ecs_task_definition" "hello_world" {
  family                   = "hello_world"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  #execution_role_arn       = "arn:aws:iam::342023131128:role/Administrator"

  container_definitions = jsonencode([
    {
      name  = "hello_world"
      #image = "nginxdemos/hello:${var.container_image_version}"
      image = "sonatype/nexus3:${var.container_image_version}"
      #image = "${var.container_ecr_url}:${var.container_image_version}" #NEEDS ENDPOINT
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    null_resource.boto3
  ]
}

# ECS service
resource "aws_ecs_service" "main" {
  name            = "hello-world-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.hello_world.arn
  desired_count   = 1 # Adjust desired count as needed
  launch_type     = "FARGATE"
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "hello_world"
    container_port   = 80
  }
  
  network_configuration {
    subnets         = aws_subnet.public[*].id
    security_groups = [aws_security_group.web_sg.id]
    assign_public_ip = true
  }

  depends_on = [
    aws_ecs_task_definition.hello_world
  ]
  # lifecycle {
  #   ignore_changes = [
  #     #desired_count,   #Can be changed by autoscaling
  #     task_definition #Can be changed by deployments (CodeDeploy)
  #   ]
  # }
}

# ALB
resource "aws_lb" "main" {
  name               = "my-load-balancer"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection = false

}

# ALB Listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

# ALB Target Group
resource "aws_lb_target_group" "main" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  target_type = "ip"  # Set target group type to "ip"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}


# ALB Target Group Attachment 
# resource "aws_lb_target_group_attachment" "ecs" {
#   target_group_arn = aws_lb_target_group.main.arn
#   target_id        = aws_ecs_service.main.id
#   port             = 80
# }

# Output the ECS cluster name
output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

# Output the ECS service name
output "ecs_service_name" {
  value = aws_ecs_service.main.name
}
