resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "vpc_endpoint_sg"
  vpc_id      = aws_vpc.vpc-us-east-1.id
  description = "SG for SSM vpc endpoint"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc-us-east-1.cidr_block]
  }
}

# variable "sg_ports" {
#   type        = list(number)
#   description = "list of ingress ports"
#   default     = [8200, 8300, 443, 80]
# }

# resource "aws_security_group" "dynamicsg" {
#   name        = "dynamic-sg"
#   description = "Ingress for EC2"

#   dynamic "ingress" {
#     for_each = var.sg_ports
#     iterator = port
#     content {
#       from_port   = port.value
#       to_port     = port.value
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }
# }




# resource "aws_security_group" "test_with_eip" {
#   name = "test_with_eip"
#   ingress {
#     from_port = 443
#     to_port = 443
#     protocol = "tcp"
#     cidr_blocks = ["${aws_eip.eip.private_ip}/32"]
#   }
# }


