# resource "aws_db_instance" "nexus_rds" {
#   identifier           = "nexus-db"
#   allocated_storage    = 20
#   storage_type         = "gp2"
#   engine               = "postgres"
#   engine_version       = "16.1"
#   instance_class       = "db.t2.micro"
#   db_name              = "nexus"
#   username             = "postgres"
#   password             = "P@ssw0rd"
#   db_subnet_group_name = aws_db_subnet_group.example.name
#   publicly_accessible = false  # Set to true if you want to make it accessible from the internet
#   # Other optional parameters:
#   # multi_az             = true
#   # backup_retention_period = 7
#   # maintenance_window  = "Mon:00:00-Mon:03:00"
#   # parameter_group_name = "default.postgres12"
# }