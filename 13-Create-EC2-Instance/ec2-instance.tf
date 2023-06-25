#Datasource for AMI id
# 
# data "aws_ami" "ubuntu" {
# most_recent = true
# owners = ["owner-name"]
# tags = {
# "Name" = "App-Server"
# Tested = true
# }
# 
# filter {
# name = "name"
# values = ["${var.image_name}"]
# }
# 
# filter {
# name = "root-device-type"
# values = "ebs"
# }
# 
# filter {
# name = "virtualization-type"
# values = "hvm"
# }
# }


# Creating an EC2 Instance

resource "aws_instance" "first-ec2-instance" {
  ami                    = var.ami
  instance_type          = var.instancetype
  iam_instance_profile   = aws_iam_instance_profile.ec2_ssm_profile.name
  key_name               = aws_key_pair.EC2-key.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = ["${aws_security_group.SG-my-security-group-01.id}", "${aws_security_group.SG-my-security-group-02.id}"]

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
  #user_data = <<EOF
  ##!/bin/bash
  #sudo yum update -y
  #sudo yum install httpd -y
  #sudo systemctl start httpd
  #sudo systemctl enable httpd
  #sudo echo "This is my new web page." >> /var/www/html/index.html
  #EOF
  user_data = file("${path.module}/userdata-script.sh")

  #### Copy file from local to EC2 Instances.
  ### We an define connection as global and provisioner automaticly call that connection.
  ### If you want to pass any other connection then you can define other connection or you 
  ### can pass manually.

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file("${path.module}/ec2-sshkey")
  }

  provisioner "file" {
    source      = "userdata-script.sh"      ## Terraform machine
    destination = "/tmp/userdata-script.sh" ## EC2 machine which will create
    # connection {
    # type = "ssh"
    # user = "ec2-user"
    # host = "${self.public_ip}"
    # private_key = file("${path.module}/ec2-sshkey")
    # }
  }


  #### Copy content in a file in newely created EC2 Instance

  provisioner "file" {
    content     = "This is my new EC2 instance for running web server"
    destination = "/tmp/mycontent.txt"
  }

  ### Below provisioner will get public IP of EC2 instance when that will be created.
  ### We can also run any linux command and run ansible playbook or shell script etc.

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > /tmp/ec2-publicip.txt"
  }

  ### Below provisinor will set working directory on remore machine.
  provisioner "local-exec" {
    working_dir = "/tmp"
    command     = "echo ${self.public_ip} > my-ec2-publicip.txt"
  }

  ### How do we run python commend on remmote machine.
  ### We will user python interpreter

  provisioner "local-exec" {
    interpreter = [
      "/usr/bin/python3", "-c"
    ]
    command = "print('Hello World')"
  }

  ### Below provisinoer will execute when your resourch start.
  provisioner "local-exec" {
    on_failure = continue ### If this provisioner will fail then "terraform apply" will not failed and other command will execute.
    command    = "echo 'at-create'"
  }

  ### Below provisinoer will execute when your resourch delete.
  provisioner "local-exec" {
    when    = destroy
    command = "echo 'at-delete'"
  }

  ### Remote-exec will run on remote machine

  provisioner "remote-exec" {
    inline = [
      "ifconfig > /tmp/ifconfig.output",
      "echo 'Hello, Guddu' > /tmp/test.txt"
    ]
  }
}
