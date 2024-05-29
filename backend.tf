provider "aws" {
  region = "us-east-1"
}
provider "aws" {
  region = "eu-central-1"
  alias  = "central"
}

# provider "aws" {
#   alias = "westcoast"
#   region = "us-west-1"
#   profile = "account02"
# }

terraform {
  backend "remote" {
    organization = "compan"
    workspaces {
      name = "compan-workspace"
    }
  }
}