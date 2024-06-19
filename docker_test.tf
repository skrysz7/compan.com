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
  target = "${aws_ecr_repository.this.repository_url}:latest"
}

#############
# resource "aws_db_snapshot" "test" {
#   db_instance_identifier = aws_db_instance.bar.identifier
#   db_snapshot_identifier = "testsnapshot:${var.version}"

#   depends_on = [var.version]
# }

resource "aws_ebs_snapshot" "example_snapshot" {
  volume_id = "vol-07e74b7de6bcd8f5e"

  tags = {
    Name = "testsnapshot:${var.version_ebs}"
  }
}


