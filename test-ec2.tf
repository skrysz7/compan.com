module "ec2-windows" {
  source  = "app.terraform.io/compan/ec2-windows/aws"
  version = "1.0.9"

  hostname  = "testsrv456"
  env       = "TEST"
  vpc_id    = data.aws_vpc.this.id
  subnet_id = local.public_subnet1a[0]
  depends_on = [
    aws_kms_key.key
  ]
  kms_key = aws_kms_alias.kms_alias.name
  #   is_migrated = false
} 