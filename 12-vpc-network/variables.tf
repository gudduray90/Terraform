variable "accesskey" {}
variable "secretkey" {}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block range for vpc"
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "CIDR block range for the private subnets"
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "CIDR block range for the public subnets"
}

variable "sunbet_availability_zones" {
  type        = list(string)
  description = "availability zones for the selected region"
}