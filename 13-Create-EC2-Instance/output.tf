output "ec2_publicIP" {
  value = aws_instance.first-ec2-instance.public_ip
}

output "ec2_publicDNS" {
  value = aws_instance.first-ec2-instance.public_dns
}

output "EC2_instance_ID" {
  value = aws_instance.first-ec2-instance.id
}

output "EC2_SG_ID_01" {
  value = aws_security_group.SG-my-security-group-01.id
}

output "EC2_SG_ID_02" {
  value = aws_security_group.SG-my-security-group-02.id
}