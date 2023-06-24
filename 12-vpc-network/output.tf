output "vpcid" {
  value = aws_vpc.Prod_VPC.id
}

output "Prod_IGW_ID" {
  value = aws_internet_gateway.prod_gw.id
}