module "ec2-windows" {
  source  = "app.terraform.io/compan/ec2-windows/aws"
  version = "1.0.16"

  hostname = "testsrv456"
  env      = "TEST"
  # vpc_id    = aws_vpc.vpc-us-east-1.id
  # subnet_id = aws_subnet.public-us-east-1[0]
  vpc_id    = "vpc-0049e1e522019fd1e"
  subnet_id = "subnet-0e0b88f9d0e85c39e"
  extra_sgs = [aws_security_group.vpc_endpoint_sg]

  depends_on = [
    aws_kms_key.key
  ]
  kms_key = aws_kms_alias.kms_alias.name
  #   is_migrated = false
} 