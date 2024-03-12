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