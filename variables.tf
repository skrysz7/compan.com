variable "project_name" {
    default = "compan.com"
}

variable "aws_region" {
    default = "us-east-1"  
}

variable "public_subnets" {
  type = list(any)
  default = [ 
    "10.0.1.0/24",
    "10.0.2.0/24"
   ]
}

variable "private_subnets" {
  type = list(any)
  default = [ 
    "10.0.3.0/24",
    "10.0.4.0/24"
   ]
}