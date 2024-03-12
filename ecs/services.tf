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


# resource "aws_ecs_service" "adservice" {
#   name            = "adservice"
#   cluster         = aws_ecs_cluster.boutique.id
#   task_definition = "arn:aws:ecs:us-east-1:342023131128:task-definition/adservice:2"
#   desired_count   = 1
#   iam_role        = aws_iam_role.admin.arn
#   launch_type     = "FARGATE"
# }