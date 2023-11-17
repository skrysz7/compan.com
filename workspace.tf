# variable "instance_type_workspace" {
#     type = map
#     default = {
#         default = "t2.nano"
#         dev     = "t2.micro"
#         prd     = "t2.large"
#     }
# }

# resource "aws_instance" "ec2_ws" {
#     instance_type = lookup(var.instance_type_workspace,terraform.workspace)
#     ami = "ami"
# }