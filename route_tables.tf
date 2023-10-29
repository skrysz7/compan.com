resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc-us-east-1.id
  tags = merge(local.tags-general, {
    Neme = "Public subnets route table"
  })
}

resource "aws_route" "public_route" {
    route_table_id = aws_route_table.public_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-us-east-1.id
  }

resource "aws_route_table_association" "public-1a" {
    count = length(var.public_subnets)
    subnet_id = aws_subnet.public-us-east-1a.id
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public-1b" {
    count = length(var.public_subnets)
    subnet_id = aws_subnet.public-us-east-1b.id
    route_table_id = aws_route_table.public_route_table.id
}