variable "autobackup_vault_account_role_arn" {
  type        = string
  description = "ARN of the AutoBackup role from Backup/Vault account which needs access to KMS key"
  default     = "arn:aws:iam::ACCOUNT_NR:role/backup-VAULT-123"
}

variable "firewall_tags" {
  default = {}
  type    = map(string)
}

variable "nexus_rds_identifier" {
  type    = string
}
variable "nexus_rds_engine" {
  default = "postgres"
  type    = string
}

variable "nexus_rds_engine_version" {
  default = "16.1"
}

variable "nexus_rds_db_family" {
  default = "postgres16"
  type    = string
}

variable "nexus_rds_major_engine_version" {
  default = "16"
  type    = string
}

variable "nexus_rds_instance_class" {
  default = "db.t3.xlarge"
  type    = string
}

variable "nexus_rds_storage_type" {
  default = "gp3"
  type    = string
}

variable "nexus_rds_secret_name" {
  type    = string
}

variable "nexus_rds_allocated_storage" {
  default = 30
  type    = number
}

variable "nexus_rds_max_allocated_storage" {
  default = 60
  type    = number
}

variable "nexus_rds_iops" {
  default = 3000
  type    = number
}
variable "nexus_container_port" {
  default = 8080
  type    = number
}
variable "container_name" {
  type    = string
  default = "xms-nexus"
}
variable "container_image_version" {
  type    = string
  default = "latest"
}

variable "container_cpu" {
  type    = number
  default = 2048
}

variable "container_memory" {
  type    = number
  default = 4096
}

variable "container_efs_path" {
  type    = string
  default = "/nexus-data"
}

variable "nexus_domain" {
  type    = string
}

variable "efs_throughput_in_mibps" {
  type = string 
  default = 100
}

variable "create_migration_instance" {
  type    = bool
}

variable "create_intg_migration_instance" {
  type    = bool
}

variable "service_connect_namespace" {
  default = "boutique"
  type    = string
}

variable "public_subnet1_id" {
  description = "ID of subnet1"
  default = "public-subnet-east-1a"
}

variable "public_subnet2_id" {
  description = "ID of subnet2"
  default = "public-subnet-east-1b"
}

variable "private_subnet1_id" {
  description = "ID of subnet1"
  default = "private-subnet-east-1a"
}

variable "private_subnet2_id" {
  description = "ID of subnet2"
  default = "private-subnet-east-1b"
}

variable "vpc_id" {
  default = "aws_vpc.vpc-us-east-1.id"
}

variable "kms_key_id" {
  type = string
}