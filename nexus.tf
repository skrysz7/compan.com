module "nexus" {
    source = "./nexus"
    nexus_domain = "nexus-intg.helvetia.group"
    nexus_rds_secret_name = "intg/nexus-rds"
    nexus_rds_identifier = "xms-nexus-intg"
    create_migration_instance = false
    create_intg_migration_instance = true
    kms_key_id = aws_kms_key.key.arn
    vpc_id              = aws_vpc.vpc-us-east-1.id
}