module "codebuild" {
    source = "./codebuild"
    nexus_domain = "nexus-intg.helvetia.group"
    nexus_rds_secret_name = "intg/nexus-rds"
    nexus_rds_identifier = "xms-nexus-intg"
    create_migration_instance = false
    create_intg_migration_instance = true
    
}