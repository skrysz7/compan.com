# resource "aws_iam_role" "admin" {
#   name                 = "ECS_AdministratorAccess"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       },
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "admin" {
#   role       = aws_iam_role.admin.name
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
# }