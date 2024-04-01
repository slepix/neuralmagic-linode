variable "linode_token" {
  default = "PUTyourTOKENhere"
  type = string
  sensitive   = true
}

variable "primary_region" {
  default = "nl-ams"
  type = string
}

variable "vmcount" {
  default = 2
}


