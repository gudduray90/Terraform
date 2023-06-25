
#Creating EC2 security group. This is normal methor

resource "aws_security_group" "SG-my-security-group-01" {
  name        = "SG-my-security-group-01"
  description = "Allow 22 port inbound traffic"
  vpc_id      = var.vpc_id

  ### ssh
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "SG-my-security-group-01"
  }

  ### HTTP
  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ###HTTPS
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

#We can allow multiple port in one go.


resource "aws_security_group" "SG-my-security-group-02" {
  name        = "SG-my-security-group-02"
  description = "Allow 80 and 443 port inbound traffic"


  dynamic "ingress" {
    for_each = [80, 443]
    iterator = port
    content {
      description = "TLS from VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  tags = {
    Name = "SG-my-security-group-02"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}