resource "aws_internet_gateway" "igw-us-east-1" {
  vpc_id = aws_vpc.vpc-us-east-1.id

  tags = {
    Neme = "igw-us-east-1"
  }
}