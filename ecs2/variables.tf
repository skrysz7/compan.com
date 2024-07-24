variable "container_image_version" {
  type    = string
  default = "0.2"
}

variable "rollback" { 
  description = "Flag to control the creation of the DB snapshot"
  type    = bool
  default = false
}

variable "container_ecr_url" {
  type = string
  default = "342023131128.dkr.ecr.eu-central-1.amazonaws.com/nexus"
}
