# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 4.0"
#     }
#     dockerless = {
#       source  = "nullstone-io/dockerless"
#       version = "~> 0.2"
#     }
#   }
# }

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
