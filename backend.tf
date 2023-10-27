provider "aws" {
    region = "us-east-1"
}

terraform {
  backend "remote" {
    organization = "compan"
    workspaces {
      name = "compan-workspace"
    }
  }
}