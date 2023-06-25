output "publicIP" {
  value = aws_instance.ec2instance.public_ip
}