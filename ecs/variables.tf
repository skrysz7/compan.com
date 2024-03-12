variable "service_connect_namespace" {
  default = "boutique"
  type    = string
}

variable "public_subnet1_id" {
  description = "ID of subnet1"
  default = element(aws_subnet.public-us-east-1[*].id, 0)
}

variable "public_subnet2_id" {
  description = "ID of subnet2"
  default = element(aws_subnet.public-us-east-1[*].id, 1)
}