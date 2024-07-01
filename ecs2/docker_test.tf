resource "aws_ssm_parameter" "rds_db_snapshot" {
  count  = var.rollback == "no" ? 1 : 0
  name   = "/nexus/rds-db-snapshot/name"
  type   = "SecureString"
  value  = aws_db_snapshot.create_rds_snapshot[0].db_snapshot_identifier
  #value  = aws_db_snapshot.create_rds_snapshot.db_snapshot_identifier
  #key_id = aws_kms_key.key.arn

  # lifecycle {
  #   ignore_changes = [
  #     value
  #   ]
  # }
}

# Paramter store to store latest working image version in case of rollback
resource "aws_ssm_parameter" "nexus_image_version" {
  count  = var.rollback == "no" ? 1 : 0
  name   = "/nexus/image/version"
  type   = "SecureString"
  value  = var.container_image_version
  #value  = "CHANGE-ME"
  #key_id = aws_kms_key.key.arn

  # lifecycle {
  #   ignore_changes = [
  #     value
  #   ]
  # }
}

locals {
  # Generating current date and time in the format: YYYY-MM-DD-HH-MM-SS 
  snapshot_timestamp = formatdate("YYYY-MM-DD-HH-mm-ss", timestamp())
  snapshot_identifier = "test-version-upgrade-${local.snapshot_timestamp}"
}

resource "aws_db_snapshot" "create_rds_snapshot" {
  count                  = var.rollback == "no" ? 1 : 0
  db_instance_identifier = "test"
  db_snapshot_identifier = local.snapshot_identifier
}

# resource "dockerless_remote_image" "alpine_latest" {
#   source = "alpine:latest"
#   target = "${aws_ecr_repository.this.repository_url}:latest"
# }

# resource "null_resource" "create_rds_snapshot" {
#   triggers = {
#     container_image_version = var.container_image_version
#   }
#   provisioner "local-exec" {
#     command = <<EOT
#       aws rds create-db-snapshot --region eu-central-1 \
#       --db-instance-identifier "test" \
#       --db-snapshot-identifier ${local.snapshot_identifier}
#     EOT
#   }
# }

# resource "null_resource" "parameter_store_image" {
#   triggers = {
#     container_image_version = var.container_image_version
#   }
#   provisioner "local-exec" {
#     command = <<EOT
#       CLUSTER_NAME=${aws_ecs_cluster.main.name}
#       SERVICE_NAME=${aws_ecs_service.main.name}
#       PARAMETER_NAME=${aws_ssm_parameter.nexus_image_version.name}
#       REGION="eu-central-1"
      
#       TASK_ARN=$(aws ecs list-tasks --region $REGION --cluster $CLUSTER_NAME --service-name $SERVICE_NAME --query 'taskArns[0]' --output text)
#       TASK_DEFINITION_ARN=$(aws ecs describe-tasks --region $REGION --cluster $CLUSTER_NAME --tasks $TASK_ARN --query 'tasks[0].taskDefinitionArn' --output text)
#       IMAGE_NAME=$(aws ecs describe-task-definition --region $REGION --task-definition $TASK_DEFINITION_ARN --query 'taskDefinition.containerDefinitions[0].image' --output text)
#       aws ssm put-parameter --region $REGION --name $PARAMETER_NAME --value $IMAGE_NAME --type "SecureString" --overwrite
#     EOT
#   }
#   depends_on = [
#     null_resource.create_rds_snapshot
#   ]
# }


# resource "null_resource" "parameter_store_rds" {
#   triggers = {
#     container_image_version = var.container_image_version
#   }
#   provisioner "local-exec" {
#     command = <<EOT
#       REGION="eu-central-1"
#       aws ssm put-parameter --region $REGION --name ${aws_ssm_parameter.rds_db_snapshot.name} --value ${local.snapshot_identifier} --type SecureString --overwrite
#     EOT
#   }
#   depends_on = [
#     null_resource.create_rds_snapshot
#   ]
# }

# resource "dockerless_remote_image" "alpine_latest" {
#   source = "alpine:latest"
#   target = "${aws_ecr_repository.this.repository_url}:latest"
# }

# terraform { 
#   required_providers {
#     # aws = {
#     #   source  = "hashicorp/aws"
#     #   version = "~> 5.52"
#     # }
#     dockerless = {
#       source  = "nullstone-io/dockerless"
#       version = "~> 0.1.1"
#     }
#   }
# }

# provider "aws" {
#    region = "eu-central-1"
# }

# resource "aws_ecr_repository" "this" {
#   name = "my-app"
# }

# data "aws_caller_identity" "this" {}

# data "aws_region" "current" {}

# data "aws_ecr_authorization_token" "temporary" {
#   registry_id = data.aws_caller_identity.this.account_id
# }

# provider "dockerless" {
#   registry_auth = {
#     "${data.aws_caller_identity.this.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com" = {
#       username = data.aws_ecr_authorization_token.temporary.user_name
#       password = data.aws_ecr_authorization_token.temporary.password
#     }
#   }
# }

# resource "dockerless_remote_image" "alpine_latest" {
#   source = "alpine:latest"
#   target = "${aws_ecr_repository.this.repository_url}:latest"
# }

# #############
# # resource "aws_db_snapshot" "test" {
# #   db_instance_identifier = aws_db_instance.bar.identifier
# #   db_snapshot_identifier = "testsnapshot:${var.version}"

# #   depends_on = [var.version]
# # }

# variable "ebs_snapshot" {
#   default = "yes"
# }

# resource "aws_ebs_snapshot" "example_snapshot" {
#   volume_id = "vol-07e74b7de6bcd8f5e"
#   count = var.ebs_snapshot == "yes" ? 1 : 0
#   tags = {
#     Name = "testsnapshot:${timestamp()}"
#   }
# #   lifecycle {
# #     prevent_destroy = true
# #   }
# }

# resource "null_resource" "take_ebs_snap" { 
#     provisioner "local-exec" {
#         command = <<-EOF
#             # Create EBS Snapshot and get the Snapshot ID
#             SNAPSHOT_ID=$(aws ec2 create-snapshot --volume-id vol-07e74b7de6bcd8f5e --tag-specifications 'ResourceType=snapshot,Tags=[{Key=Name,Value=ebs-snapshot-'"$(date +'%Y-%m-%d-%H-%M-%S')"'}]' --region us-east-1 --query 'SnapshotId' --output text)

#             # Store Snapshot ID in Parameter Store with a static parameter name
#             aws ssm put-parameter --name "/snapshots/ebs_snap" --value "$SNAPSHOT_ID" --type String --region us-east-1

#         EOF
#         interpreter = ["/bin/bash", "-c"]
#     }
# }
# provider "null" {
#   version = "~> 3.0"
# } 