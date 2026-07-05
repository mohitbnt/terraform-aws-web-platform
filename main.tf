module "network" {
  source               = "./modules/network"
  common_tags          = local.common_tags
  environment          = local.environment
  project_name         = local.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "security" {
  source       = "./modules/security"
  common_tags  = local.common_tags
  environment  = local.environment
  project_name = local.project_name
  vpc_id       = module.network.vpc_id
}


# Routes
###############################################################
resource "aws_route" "public_route" {
  route_table_id         = module.network.public_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.network.igw_id
}
resource "aws_route" "private_route" {
  route_table_id         = module.network.private_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.nat_instance.primary_network_interface_id
}

# VPC Endpoints for private EC2 SSM access
resource "aws_vpc_endpoint" "ssm_enpoints" {
  for_each            = local.interface_endpoints
  vpc_id              = module.network.vpc_id
  service_name        = each.value
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.network.private_subnet_ids
  security_group_ids  = [module.security.endpoint_security_group_id]
  private_dns_enabled = true
  tags = {
    Name = "${var.environment}-${var.project_name}-${each.key}-endpoint"
  }
}