module "ec2-windows" {
  source  = "app.terraform.io/compan/ec2-windows/aws"
  version = "1.0.8"

  hostname = "testsrv456"
  env      = "TEST"
  depends_on = [
    aws_kms_key.key
  ]
  kms_key  = aws_kms_alias.kms_alias.name
  #   is_migrated = false
} 