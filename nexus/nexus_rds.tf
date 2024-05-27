module "nexus_rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.5.3"

  identifier = "nexus-intg"

  create_db_option_group    = false
  create_db_parameter_group = false

  create_db_subnet_group = true
  subnet_ids             = ["subnet-0a1e9f602c5b302ad"]

  multi_az = false

  engine               = var.nexus_rds_engine
  engine_version       = var.nexus_rds_engine_version
  family               = var.nexus_rds_db_family
  major_engine_version = var.nexus_rds_major_engine_version
  instance_class       = var.nexus_rds_instance_class

  kms_key_id                      = var.kms_key_id
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  create_cloudwatch_log_group     = true

  create_monitoring_role = true
  monitoring_interval    = 60


  allocated_storage     = var.nexus_rds_allocated_storage
  storage_type          = var.nexus_rds_storage_type
  max_allocated_storage = var.nexus_rds_max_allocated_storage
  #iops                  = var.nexus_rds_iops

  db_name  = "nexus"
  username = "postgres"
  port     = 5432

  # setting manage_master_user_password_rotation to false after it
  # has been set to true previously disables automatic rotation
  manage_master_user_password_rotation              = false
  master_user_password_rotate_immediately           = false
  master_user_password_rotation_schedule_expression = "rate(15 days)"

  vpc_security_group_ids = [aws_security_group.nexus_rds_sg.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  skip_final_snapshot     = true
  backup_retention_period = 30

  timeouts = {
    create = "3h"
    delete = "3h"
    update = "3h"
  }
}
