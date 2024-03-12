# variable "ecs_services" {
#   type    = list(string)
#   default = ["adservice","cartservice","checkoutservice","currencyservice","emailservice","frontend","my-webserver-image","paymentservice","productcatalogservice","recommendationservice","shippingservice"]
# }

# variable "my_map" {
#   type = map(string)
#   default = {
#     "adservice"   = "arn:aws:ecs:us-east-1:342023131128:task-definition/adservice:2"
#     "cartservice" = "arn:aws:ecs:us-east-1:342023131128:task-definition/cartservice:2"
#   }
# }

resource "aws_ecs_service" "currency" {
  name            = "currencyservice"
  cluster         = aws_ecs_cluster.boutique.id
  task_definition = "arn:aws:ecs:us-east-1:342023131128:task-definition/currencyservice:3"
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = [var.private_subnet1_id]
    security_groups = ["sg-01d1755e60e9fd5ad"]
    assign_public_ip = false
  }

  service_connect_configuration {
    enabled = true
    namespace = aws_service_discovery_http_namespace.boutique_namespace.arn
    service {
      client_alias {
        dns_name = "currencyservice"
        port = "7000"
      }
      discovery_name = "currencyservice"
      port_name = "currencyservice"
    }
}
  depends_on      = []
}

resource "aws_ecs_service" "shippingservice" {
  name            = "shippingservice"
  cluster         = aws_ecs_cluster.boutique.id
  task_definition = "arn:aws:ecs:us-east-1:342023131128:task-definition/shippingservice:1"
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = [var.private_subnet1_id]
    security_groups = ["sg-01d1755e60e9fd5ad"]
    assign_public_ip = false
  }

  service_connect_configuration {
    enabled = true
    namespace = aws_service_discovery_http_namespace.boutique_namespace.arn
    service {
      client_alias {
        dns_name = "shippingservice"
        port = "50051"
      }
      discovery_name = "shippingservice"
      port_name = "shippingservice"
    }
}
  depends_on      = []
}





# resource "aws_ecs_service" "adservice" {
#   name            = "adservice"
#   cluster         = aws_ecs_cluster.boutique.id
#   task_definition = "arn:aws:ecs:us-east-1:342023131128:task-definition/adservice:2"
#   desired_count   = 1
#   launch_type     = "FARGATE"

#   network_configuration {
#     subnets = [var.public_subnet1_id]
#     security_groups = ["sg-01d1755e60e9fd5ad"]
#     assign_public_ip = true
#   }

#   service_connect_configuration {
#     enabled = true
#     namespace = aws_service_discovery_http_namespace.boutique_namespace.arn
#     service {
#       client_alias {
#         dns_name = "adservice"
#         port = "9555"
#       }
#       discovery_name = "adservice"
#       port_name = "adservice"
#     }
# }
#   # alarms {
#   #   enable   = true
#   #   rollback = true
#   #   alarm_names = [
#   #     aws_cloudwatch_metric_alarm.example.alarm_name
#   #   ]
#   # }

#   depends_on      = []
# }