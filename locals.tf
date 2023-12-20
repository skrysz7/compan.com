locals {
  tags-general = {
    "Organization" = "compan.com"
  }

  public_subnet1a = [for subnet in aws_subnet.public-us-east-1 : subnet.id if subnet.availability_zone == "us-east-1a"]
  public_subnet1b = [for subnet in aws_subnet.public-us-east-1 : subnet.id if subnet.availability_zone == "us-east-1b"]
}