# resource "aws_service_discovery_http_namespace" "boutique_namespace" {
#   name        = "boutique"
#   description = "boutique"
# }

# resource "aws_ecs_cluster" "boutique" {
#   name = "boutique"

#   setting {
#     name  = "containerInsights"
#     value = "enabled"
#   }

#   service_connect_defaults {
#     namespace = aws_service_discovery_http_namespace.boutique_namespace.arn
#   }

#   configuration {
#     execute_command_configuration {
#         logging    = "OVERRIDE"
#         log_configuration {
#             cloud_watch_encryption_enabled = true
#             cloud_watch_log_group_name     = aws_cloudwatch_log_group.boutique_lg.name
#         }
#     }
#   }
# #   service_connect_defaults {
# #     namespace = var.service_connect_namespace
# #   }
# }

# resource "aws_cloudwatch_log_group" "boutique_lg" {
#   name = "boutique_log_group"
# }