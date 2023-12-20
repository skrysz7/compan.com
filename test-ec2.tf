module "ec2-windows" {
  source  = "app.terraform.io/compan/ec2-windows/aws"
  version = "1.0.7"

  hostname = "testsrv456"
  env      = "TEST"
  kms_key  = aws_kms_alias.kms_alias.name
  #   is_migrated = false
} 