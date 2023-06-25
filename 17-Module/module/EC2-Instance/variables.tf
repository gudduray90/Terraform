variable "image_id" {
    type = string  
}

variable "instancetype" {
  type = string
}

variable "ssh_key" {
  type = string
}
variable "vpc_id" {
  type = string
  default = "vpc-3d686355"
}
variable "ec2_volume_type" {}
variable "ec2_volume_size" {}
variable "environment" {
  type = string  
}