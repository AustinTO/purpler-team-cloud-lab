variable "env" {
  type    = string
  default = "dev"
}

variable "cidr_prefix" {
  type    = string
#  default = "172.16"
  default = "192.168"
}

