# Internet Gateway
###############################################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${local.environment}-${local.common_tags.Project}-igw"
  }
}

# Subnets
###############################################################
resource "aws_subnet" "public_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  availability_zone       = local.first_two_azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.environment}-${local.common_tags.Project}-public-az${count.index + 1}"
  }
}
resource "aws_subnet" "private_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.${count.index + 3}.0/24"
  availability_zone       = local.first_two_azs[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${local.environment}-${local.common_tags.Project}-private-az${count.index + 1}"
  }
}

# Route Tables
###############################################################
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${local.environment}-${local.common_tags.Project}-public-rt"
  }
}
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${local.environment}-${local.common_tags.Project}-private-rt"
  }
}

# Routes
###############################################################
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.nat_instance.primary_network_interface_id
}

# Route Table Associations
###############################################################
resource "aws_route_table_association" "public_rt_associations" {
  count          = 2
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}
resource "aws_route_table_association" "private_rt-associations" {
  count          = 2
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}

# VPC Endpoints for private EC2 SSM access
resource "aws_vpc_endpoint" "ssm_enpoints" {
  for_each            = local.interface_endpoints
  vpc_id              = aws_vpc.main_vpc.id
  service_name        = each.value
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private_subnet[*].id
  security_group_ids  = [aws_security_group.endpoints_sg.id]
  private_dns_enabled = true
  tags = {
    Name = "${local.environment}-${local.common_tags.Project}-${each.key}-endpoint"
  }
}