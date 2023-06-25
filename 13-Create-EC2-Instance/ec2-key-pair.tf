# Creating SSH key for EC2

resource "aws_key_pair" "EC2-key" {
  key_name   = "EC2-key"
  public_key = file("${path.module}/ec2-sshkey.pub")
}