# provider "aws" {
#   region = "eu-central-1"
# }

# # Create a VPC
# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"
# }

# # Create public subnets
# resource "aws_subnet" "public" {
#   count             = 2
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.${count.index}.0/24"
#   availability_zone = element(["eu-central-1a", "eu-central-1b"], count.index)
# }

# # Create an internet gateway
# resource "aws_internet_gateway" "main" {
#   vpc_id = aws_vpc.main.id
# }

# # Create a route table
# resource "aws_route_table" "main" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.main.id
#   }
# }

# # Associate the route table with the subnets
# resource "aws_route_table_association" "public" {
#   count          = 2
#   subnet_id      = element(aws_subnet.public.*.id, count.index)
#   route_table_id = aws_route_table.main.id
# }

# # Security group to allow HTTP traffic
# resource "aws_security_group" "web_sg" {
#   vpc_id = aws_vpc.main.id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # ECS cluster
# resource "aws_ecs_cluster" "main" {
#   name = "my-cluster"
# }

# # Task definition
# resource "aws_ecs_task_definition" "hello_world" {
#   family                   = "hello_world"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = "256"
#   memory                   = "512"

#   container_definitions = jsonencode([
#     {
#       name  = "hello_world"
#       image = "nginxdemos/hello"
#       essential = true
#       portMappings = [
#         {
#           containerPort = 80
#           hostPort      = 80
#         }
#       ]
#     }
#   ])
# }

# # ECS service
# resource "aws_ecs_service" "main" {
#   name            = "hello-world-service"
#   cluster         = aws_ecs_cluster.main.id
#   task_definition = aws_ecs_task_definition.hello_world.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"
  
#   network_configuration {
#     subnets         = aws_subnet.public[*].id
#     security_groups = [aws_security_group.web_sg.id]
#   }
# }

# # Output the ECS cluster name
# output "ecs_cluster_name" {
#   value = aws_ecs_cluster.main.name
# }

# # Output the ECS service name
# output "ecs_service_name" {
#   value = aws_ecs_service.main.name
# }
