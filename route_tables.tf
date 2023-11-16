resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc-us-east-1.id
  tags = merge(local.tags-general, {
    Neme = "Public subnets route table"
  })
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw-us-east-1.id
}

resource "aws_route_table_association" "public-1a" {
  subnet_id      = local.public_subnet1a[0]
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public-1b" {
  subnet_id      = local.public_subnet1b[0]
  route_table_id = aws_route_table.public_route_table.id
}