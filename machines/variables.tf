variable "env" {
  type    = string
  default = "dev"
}

variable "subnet_cidr_prefix" {
  description = "Default subnet CIDR prefix for the DC/Win instance"
  type        = string
  default     = "172.16.10"
}

variable "blueteam_subnet_cidr_prefix" {
  description = "Default subnet CIDR prefix for the Blue Team machine"
  type        = string
  default     = "172.16.20"
}

variable "attacker_subnet_cidr_prefix" {
  description = "Default subnet CIDR prefix for the Red Team machine"
  type        = string
  default     = "172.16.30"
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "blueteam_subnet_id" {
  type = string
}

variable "attacker_subnet_id" {
  type = string
}

variable "default_password" {
  description = "The Administrator password for Windows instances"
  type        = string
  default     = "LabPass1"
}

variable "adlab_domain" {
  description = "The Active Directory domain name"
  type        = string
  default     = "adlab.local"
}

variable "key_name" {
  description = "The name of the AWS EC2 key pair"
  type        = string
  default     = "ec2_key_pair"
}

variable "external_whitelist_ip" {
  description = "The IP address (in CIDR notation) to whitelist for external connections (WinRM, RDP, SSH, etc.)"
  type        = string
  default     = "0.0.0.0/0"
}
