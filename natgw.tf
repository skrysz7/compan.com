# resource "aws_eip" "eip_natgw" {
#   domain = "vpc"
# }

# resource "aws_nat_gateway" "natgw" {
#   allocation_id = aws_eip.eip_natgw.id
#   subnet_id     = element(aws_subnet.public-us-east-1[*].id, 0)

#   tags = {
#     Name = "gw NAT"
#   }

#   # To ensure proper ordering, it is recommended to add an explicit dependency
#   # on the Internet Gateway for the VPC.
#   depends_on = [aws_internet_gateway.igw-us-east-1]
# }