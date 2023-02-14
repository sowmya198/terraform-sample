variable "myip" {
  type    = string
  default = "45.0.0.0/8"
}

variable "EC2_ROOT_VOLUME_SIZE" {
  type = string
  default = "8"
}

variable "EC2_ROOT_VOLUME_TYPE" {
  type = string
  default = "standard"
}
