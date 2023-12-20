variable "project_name" {
  default = "compan.com"
}

variable "aws_region" {
  default = "us-east-1"
  type    = string
}

variable "public_subnets_cidr" {
  type = list(any)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}
variable "private_subnets_cidr" {
  type = list(any)
  default = [
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]
}

variable "public_subnet_names" {
  type    = list(any)
  default = ["public-subnet-east-1a", "public-subnet-east-1b"]
}

variable "private_subnet_names" {
  type    = list(any)
  default = ["private-subnet-east-1a", "private-subnet-east-1b"]
}

variable "availability_zone" {
  type    = list(any)
  default = ["us-east-1a", "us-east-1b"]
}

variable "istest" {
  default = false
}