resource "aws_security_group" "elb_security_group" {
  name        = "elb_security_group"
  vpc_id      = var.vpc_id
  description = "Security group for elb"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "elb_security_group"
  }
}