######################## VPC ####################
resource "aws_vpc" "Prod_VPC" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = merge(
    local.common_tags,
    tomap({
      "Name"                                            = "${local.environment} - vpc"
      "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    })
  )
}
####################### Public Subnet ###############
resource "aws_subnet" "Public_Subnet" {
  count                   = length(var.public_subnet_cidr_blocks)
  vpc_id                  = aws_vpc.Prod_VPC.id
  cidr_block              = element(var.public_subnet_cidr_blocks, count.index)
  availability_zone       = element(var.sunbet_availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = merge(
    local.common_tags,
    tomap({
      "Name"                                            = "${local.environment} - public - ${count.index}"
      "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
      "kubernetes.io/role/elb"                          = "1"
    })
  )
}

################### Private Subnet ########################
resource "aws_subnet" "Private_Subnet" {
  count                   = length(var.private_subnet_cidr_blocks)
  vpc_id                  = aws_vpc.Prod_VPC.id
  cidr_block              = element(var.private_subnet_cidr_blocks, count.index)
  availability_zone       = element(var.sunbet_availability_zones, count.index)
  map_public_ip_on_launch = false
  tags = merge(
    local.common_tags,
    tomap({
      "Name"                                            = "${local.environment} - private - ${count.index}"
      "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
      "kubernetes.io/role/internal-elb"                 = 1
    })
  )
}

######################## Internet Gateway #######################

resource "aws_internet_gateway" "prod_gw" {
  vpc_id = aws_vpc.Prod_VPC.id
  tags = merge(
    local.common_tags,
    tomap({ "Name" = local.environment })
  )
}

######################## Route Table associate with IGW ############################

resource "aws_route_table" "Public_Route" {
  vpc_id = aws_vpc.Prod_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod_gw.id
  }
  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.environment} - Public" })
  )
}

################### Public Subnet Association with Main Route Table #####################

resource "aws_route_table_association" "Public_Route_Sub_acssociate" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = element(aws_subnet.Public_Subnet.*.id, count.index)
  route_table_id = aws_route_table.Public_Route.id
}