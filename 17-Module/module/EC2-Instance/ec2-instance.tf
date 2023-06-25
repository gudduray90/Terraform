######################## Creating EC2 Instance #############
resource "aws_instance" "ec2instance" {
  ami                    = var.image_id
  instance_type          = var.instancetype
  key_name               = var.ssh_key
  iam_instance_profile   = aws_iam_instance_profile.ssm_instance_profile.name
  vpc_security_group_ids = [aws_security_group.security-group.id]
  
  root_block_device {
    delete_on_termination = true
    volume_type           = "${var.ec2_volume_type}"
    volume_size           = "${var.ec2_volume_size}"
    encrypted             = "true"
    iops                  = "3000"
    throughput            = "125"
    tags = {
      Name                   = "root_volume"
      envirenment            = "${var.environment}"
    }
  }  
  tags = {
    Name = "first-ec2-instance"
  }
}

#######################Createing Iam Instance Profile role ######################
resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ssm_instance_profile"
  role = aws_iam_role.ssm-full-role.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ssm-full-role" {
  name               = "ssm-full-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "attache_policy_with_role" {
  role       = aws_iam_role.ssm-full-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}


variable "ingress_rules" {
  default = [{
       from_port   = 22
       to_port     = 22
       description = "Port 22 SSH"
   },
   {
       from_port   = 80
       to_port     = 80
       description = "Port 80 HTTP"
   }]
}

######################## Creating Security Group ########################
resource "aws_security_group" "security-group" {
   name   = "EC2_SG"

   dynamic "ingress" {
       for_each = var.ingress_rules

       content {
           description = ingress.value.description
           from_port   = ingress.value.from_port   
           to_port     = ingress.value.to_port     
           protocol    = "tcp"
           cidr_blocks = ["0.0.0.0/0"]
       }
   }
}

