resource "aws_vpc" "vpc-us-east-1" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name    = "vpc-us-east-1"
    Company = "compan.com"
  }
}


resource "aws_vpc_endpoint" "ssm" {
  vpc_id             = aws_vpc.vpc-us-east-1.id
  service_name       = "com.amazonaws.us-east-1.ssm"
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids         = [aws_subnet.private-us-east-1[*].id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = aws_vpc.vpc-us-east-1.id
  service_name        = "com.amazonaws.us-east-1.ssmmessages"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids          = [aws_subnet.private-us-east-1[*].id]
  private_dns_enabled = true
}
