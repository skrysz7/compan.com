locals {
  tags-general = {
    "Organization" = "compan.com"
  }

  public_subnet1a = [for subnet in aws_subnet.public-us-east-1 : subnet.id if subnet.availability_zone == "us-east-1a"]
  public_subnet1b = [for subnet in aws_subnet.public-us-east-1 : subnet.id if subnet.availability_zone == "us-east-1b"]

  private_subnets = {
    private_subnet1a = { id = "subnet-0e0b88f9d0e85c39e"}
    private_subnet1b = { id = "subnet-08d2a03679d13feaf"}
  }
}
