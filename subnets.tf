resource "aws_subnet" "private-us-east-1" {
  vpc_id            = aws_vpc.vpc-us-east-1.id
  count             = 2
  availability_zone = element(var.availability_zone, count.index)
  cidr_block        = element(var.private_subnets_cidr, count.index)

  tags = {
    Name = element(var.private_subnet_names, count.index)
  }
}

resource "aws_subnet" "public-us-east-1" {
  vpc_id            = aws_vpc.vpc-us-east-1.id
  count             = 2
  availability_zone = element(var.availability_zone, count.index)
  cidr_block        = element(var.public_subnets_cidr, count.index)

  tags = {
    Name = element(var.public_subnet_names, count.index)
  }
}