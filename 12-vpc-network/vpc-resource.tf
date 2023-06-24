######################## VPC ####################
resource "aws_vpc" "Prod_VPC" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name = "Prod_VPC"
  }
}
####################### Public Subnet ###############
resource "aws_subnet" "Public_Subnet" {
  count                   = length(var.public_subnet_cidr_blocks)
  vpc_id                  = aws_vpc.Prod_VPC.id
  cidr_block              = element(var.public_subnet_cidr_blocks, count.index)
  availability_zone       = element(var.sunbet_availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "Public_Subnet"
  }
}
#resource "aws_subnet" "Public_Subnet_2" {
#  vpc_id     = aws_vpc.Prod_VPC.id
#  cidr_block = "10.0.2.0/24"
#  tags = {
#    Name = "Public_Subnet_2"
#  }
#}

################### Private Subnet ########################
resource "aws_subnet" "Private_Subnet" {
  count             = length(var.private_subnet_cidr_blocks)
  vpc_id            = aws_vpc.Prod_VPC.id
  cidr_block        = element(var.private_subnet_cidr_blocks, count.index)
  availability_zone = element(var.sunbet_availability_zones, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "Private_Subnet"
  }
}

#resource "aws_subnet" "Private_Subnet_1" {
#  vpc_id     = aws_vpc.Prod_VPC.id
#  cidr_block = "10.0.3.0/24"
#  tags = {
#    Name = "Private_Subnet_1"
#  }
#}

#resource "aws_subnet" "Private_Subnet_2" {
#  vpc_id     = aws_vpc.Prod_VPC.id
#  cidr_block = "10.0.4.0/24"
#  tags = {
#    Name = "Private_Subnet_2"
#  }
#}


######################## Internet Gateway #######################

resource "aws_internet_gateway" "prod_gw" {
  vpc_id = aws_vpc.Prod_VPC.id
  tags = {
    Name = "prod_gw"
  }
}

######################## Route Table associate with IGW ############################

resource "aws_route_table" "Public_Route" {
  vpc_id = aws_vpc.Prod_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod_gw.id
  }
  tags = {
    Name = "Public_Main_Route"
  }
}

################### Public Subnet Association with Main Route Table #####################

resource "aws_route_table_association" "Public_Route_Sub_acssociate" {
  count             = length(var.public_subnet_cidr_blocks)
  subnet_id      = "${element(aws_subnet.Public_Subnet.*.id, count.index)}"
  route_table_id = aws_route_table.Public_Route.id
}