data "aws_ami" "win2022" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }
}

# data "aws_ami" "dc-compan-com" {
#   owners = ["self"]
#   filter {
#     name   = "name"
#     values = ["windows-domain-controller"]
#   }
# }