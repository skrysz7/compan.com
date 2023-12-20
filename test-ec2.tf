module "ec2-windows" {
  source  = "app.terraform.io/compan/ec2-windows/aws"
  version = "1.0.4"

  hostname = "testsrv456"
  env      = "TEST"
  #   is_migrated = false
} 