module "network" {
  source               = "./modules/network"
  common_tags          = local.common_tags
  environment          = var.environment
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "security" {
  source              = "./modules/security"
  common_tags         = local.common_tags
  environment         = var.environment
  project_name        = var.project_name
  vpc_id              = module.network.vpc_id
  enable_nat_instance = var.enable_nat_instance
}

module "iam" {
  source              = "./modules/iam"
  common_tags         = local.common_tags
  environment         = var.environment
  project_name        = var.project_name
  enable_nat_instance = var.enable_nat_instance
}

module "compute" {
  source                    = "./modules/compute"
  common_tags               = local.common_tags
  environment               = var.environment
  project_name              = var.project_name
  enable_nat_instance       = var.enable_nat_instance
  nat_instance_profile_name = module.iam.nat_instance_profile_name
  ec2_instance_profile_name = module.iam.ec2_instance_profile_name
  public_subnet_ids         = module.network.public_subnet_ids
  private_subnet_ids        = module.network.private_subnet_ids
  nat_security_group_id     = [module.security.nat_security_group_id]
  ec2_security_group_id     = [module.security.ec2_security_group_id]
  target_group_arns         = [module.loadbalancer.target_group_arns]
  nat_instance_config       = var.nat_instance_config
  application_config        = var.application_config
}

module "loadbalancer" {
  source                = "./modules/loadbalancer"
  common_tags           = local.common_tags
  environment           = var.environment
  project_name          = var.project_name
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
  certificate_arn       = module.domain.certificate_arn
}

module "domain" {
  source             = "./modules/domain"
  common_tags        = local.common_tags
  environment        = var.environment
  project_name       = var.project_name
  cloudflare_zone_id = var.cloudflare_zone_id
  domain_name        = var.domain_name
  alb_dns_name       = module.loadbalancer.alb_dns_name
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
  network_interface_id   = module.compute.nat_instance_primary_eni_id
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
  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.project_name}-${each.key}-endpoint"
    }
  )
}