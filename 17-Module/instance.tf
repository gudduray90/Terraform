module "webserver1" {
  source               = "./module/EC2-Instance"
  image_id             = var.image_id
  instancetype         = var.instancetype
  ssh_key              = var.ssh_key
  ec2_volume_size      = var.ec2_volume_size
  ec2_volume_type      = var.ec2_volume_type
  environment          = var.environment
}

# module "Security-Group" {
#   source = "./module/Security-Group"
#   sg_name = "my-sg"
#   ingress_rules =    [
#        {
#            description =  "description"
#            from_port   = 22
#            to_port     = 22
#            protocol    = "tcp"
#            cidr_blocks = ["0.0.0.0/0"]
#      }
#    ]
# }

# module "Instance-profile" {
#   source = "./module/Instance-profile"
# }