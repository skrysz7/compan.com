resource "aws_subnet" "private-us-east-1a" {
  vpc_id = aws_vpc.vpc-us-east-1.id
  availability_zone = "us-east-1a"
  cidr_block = "10.0.1.0/16"

  tags = {
    Name = "private-subnet-east-1a"
  }
}

resource "aws_subnet" "private-us-east-1b" {
  vpc_id = aws_vpc.vpc-us-east-1.id
  availability_zone = "us-east-1b"
  cidr_block = "10.0.2.0/16"

  tags = {
    Name = "private-subnet-east-1b"
  }
}

resource "aws_subnet" "public-us-east-1a" {
  vpc_id = aws_vpc.vpc-us-east-1.id
  availability_zone = "us-east-1a"
  cidr_block = "10.0.3.0/16"

  tags = {
    Name = "public-subnet-east-1a"
  }
}

resource "aws_subnet" "public-us-east-1b" {
  vpc_id = aws_vpc.vpc-us-east-1.id
  availability_zone = "us-east-1b"
  cidr_block = "10.0.4.0/16"

  tags = {
    Name = "public-subnet-east-1b"
  }
}