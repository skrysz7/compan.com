variable "service_connect_namespace" {
  default = "boutique"
  type    = string
}

variable "public_subnet1_id" {
  description = "ID of subnet1"
  default = aws_subnet.public-us-east-1[0].id
}

variable "public_subnet2_id" {
  description = "ID of subnet2"
  default = aws_subnet.public-us-east-1[1].id
}