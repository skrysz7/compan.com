terraform {
  required_providers {
    # aws = {
    #   source  = "hashicorp/aws"
    #   version = "~> 5.52"
    # }
    dockerless = {
      source  = "nullstone-io/dockerless"
      version = "~> 0.1.1"
    }
  }
}

# provider "aws" {
#   region = "us-west-2" # Update to your preferred region
# }

resource "aws_ecr_repository" "this" {
  name = "my-app"
}

data "aws_caller_identity" "this" {}

data "aws_region" "current" {}

data "aws_ecr_authorization_token" "temporary" {
  registry_id = data.aws_caller_identity.this.account_id
}

provider "dockerless" {
  registry_auth = {
    "${data.aws_caller_identity.this.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com" = {
      username = data.aws_ecr_authorization_token.temporary.user_name
      password = data.aws_ecr_authorization_token.temporary.password
    }
  }
}

resource "dockerless_remote_image" "alpine_latest" {
  source = "alpine:latest"
  target = "${aws_ecr_repository.this.repository_url}:${var.version_ebs}"
}

#############
# resource "aws_db_snapshot" "test" {
#   db_instance_identifier = aws_db_instance.bar.identifier
#   db_snapshot_identifier = "testsnapshot:${var.version}"

#   depends_on = [var.version]
# }

variable "version_ebs" {
  default = "no"
}

resource "aws_ebs_snapshot" "example_snapshot" {
  volume_id = "vol-07e74b7de6bcd8f5e"
  count = var.version_ebs == "yes" ? 1 : 0
  tags = {
    Name = "testsnapshot:${var.version_ebs}"
  }
}

# resource "null_resource" "take_ebs_snap" {  
#     provisioner "local-exec" {
#         command = <<-EOF
#             # Create EBS Snapshot and get the Snapshot ID
#             SNAPSHOT_ID=$(aws ec2 create-snapshot --volume-id vol-07e74b7de6bcd8f5e --description "My EBS Snapshot on 2024-06-19" --tag-specifications 'ResourceType=snapshot,Tags=[{Key=Name,Value=ebs-snapshot-'"$(date +'%Y-%m-%d-%H-%M-%S')"'}]' --region us-east-1 --query 'SnapshotId' --output text)

#             # Store Snapshot ID in Parameter Store with a static parameter name
#             aws ssm put-parameter --name "/snapshots/ebs_snap" --value "$SNAPSHOT_ID" --type String --region us-east-1

#         EOF
#         interpreter = ["/bin/bash", "-c"]
#     }
# }
# provider "null" {
#   version = "~> 3.0"
# }


