variable "container_image_version" {
  type    = string
  default = "0.3"
}


variable "rollback" { 
  description = "Flag to control the creation of the DB snapshot"
  type    = bool
  default = false
}

