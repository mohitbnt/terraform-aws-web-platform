# VPC
###############################################################
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  lifecycle {
    precondition {
      condition     = length(var.public_subnet_cidrs) == length(var.private_subnet_cidrs)
      error_message = "The number of public subnet CIDR blocks must equal the number of private subnet CIDR blocks. Each public subnet is expected to have a corresponding private subnet in the same Availability Zone."
    }
  }
  tags = merge(var.common_tags,
    {
      Name = "${var.environment}-${var.project_name}-vpc"
    }
  )
}
# Internet Gateway
###############################################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-igw"
    }
  )
}

# Subnets
###############################################################
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = local.selected_azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.common_tags,

    {
      Name = "${var.environment}-${var.project_name}-public-az${count.index + 1}"
    }
  )
}
resource "aws_subnet" "private_subnet" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = local.selected_azs[count.index]
  map_public_ip_on_launch = false

  tags = merge(var.common_tags,

    {
      Name = "${var.environment}-${var.project_name}-private-az${count.index + 1}"
    }
  )
}

# Route Tables
###############################################################
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  tags = merge(var.common_tags,

    {
      Name = "${var.environment}-${var.project_name}-public-rt"
    }
  )
}
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id
  tags = merge(var.common_tags,

    {
      Name = "${var.environment}-${var.project_name}-private-rt"
    }
  )
}

# Route Table Associations
###############################################################
resource "aws_route_table_association" "public_rt_associations" {
  count          = length(var.public_subnet_cidrs)
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}
resource "aws_route_table_association" "private_rt_associations" {
  count          = length(var.private_subnet_cidrs)
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}