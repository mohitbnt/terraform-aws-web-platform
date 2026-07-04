# Security Groups
###############################################################
resource "aws_security_group" "nat_sg" {
  name        = "${local.environment}-${local.common_tags.Project}-nat_sg"
  description = "Security group for NAT instance"
  vpc_id      = aws_vpc.main_vpc.id
  tags = {
    Name = "${local.environment}-${local.common_tags.Project}-nat_sg"
  }
}
resource "aws_security_group" "ec2_sg" {
  name        = "${local.environment}-${local.common_tags.Project}-ec2_sg"
  description = "Security group for EC2 instance"
  vpc_id      = aws_vpc.main_vpc.id
  tags = {
    Name = "${local.environment}-${local.common_tags.Project}-ec2_sg"
  }
}
resource "aws_security_group" "alb_sg" {
  name        = "${local.environment}-${local.common_tags.Project}-alb_sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.main_vpc.id
  tags = {
    Name = "${local.environment}-${local.common_tags.Project}-alb_sg"
  }
}
resource "aws_security_group" "endpoints_sg" {
  name        = "${local.environment}-${local.common_tags.Project}-endpoints_sg"
  description = "Security group for VPC endpoints"
  vpc_id      = aws_vpc.main_vpc.id
  tags = {
    Name = "${local.environment}-${local.common_tags.Project}-endpoints_sg"
  }
}

# Ingress and Egress rules
###############################################################
# For NAT SG
resource "aws_vpc_security_group_ingress_rule" "nat_sg_ingress" {
  for_each                     = local.nat_sg_ingress_rules
  security_group_id            = aws_security_group.nat_sg.id
  from_port                    = each.value.port
  to_port                      = each.value.port
  ip_protocol                  = each.value.protocol
  cidr_ipv4                    = each.value.use_cidr ? each.value.cidr : null
  referenced_security_group_id = each.value.referenced_security_group_id
}
resource "aws_vpc_security_group_egress_rule" "nat_sg_egress" {
  for_each                     = local.nat_sg_egress_rules
  security_group_id            = aws_security_group.nat_sg.id
  from_port                    = each.value.port
  to_port                      = each.value.port
  ip_protocol                  = each.value.protocol
  cidr_ipv4                    = each.value.use_cidr ? each.value.cidr : null
  referenced_security_group_id = each.value.referenced_security_group_id
}

# For EC2 SG
resource "aws_vpc_security_group_ingress_rule" "ec2_sg_ingress" {
  for_each                     = local.ec2_sg_ingress_rules
  security_group_id            = aws_security_group.ec2_sg.id
  from_port                    = each.value.port
  to_port                      = each.value.port
  ip_protocol                  = each.value.protocol
  cidr_ipv4                    = each.value.use_cidr ? each.value.cidr : null
  referenced_security_group_id = each.value.referenced_security_group_id
}
resource "aws_vpc_security_group_egress_rule" "ec2_sg_egress" {
  for_each                     = local.ec2_sg_egress_rules
  security_group_id            = aws_security_group.ec2_sg.id
  from_port                    = each.value.port
  to_port                      = each.value.port
  ip_protocol                  = each.value.protocol
  cidr_ipv4                    = each.value.use_cidr ? each.value.cidr : null
  referenced_security_group_id = each.value.referenced_security_group_id
}

# For ALB SG
resource "aws_vpc_security_group_ingress_rule" "alb_sg_ingress" {
  for_each                     = local.alb_sg_ingress_rules
  security_group_id            = aws_security_group.alb_sg.id
  from_port                    = each.value.port
  to_port                      = each.value.port
  ip_protocol                  = each.value.protocol
  cidr_ipv4                    = each.value.use_cidr ? each.value.cidr : null
  referenced_security_group_id = each.value.referenced_security_group_id
}
resource "aws_vpc_security_group_egress_rule" "alb_sg_egress" {
  for_each                     = local.alb_sg_egress_rules
  security_group_id            = aws_security_group.alb_sg.id
  from_port                    = each.value.port
  to_port                      = each.value.port
  ip_protocol                  = each.value.protocol
  cidr_ipv4                    = each.value.use_cidr ? each.value.cidr : null
  referenced_security_group_id = each.value.referenced_security_group_id
}

# For Endpoints SG
resource "aws_vpc_security_group_ingress_rule" "endpoints_sg_ingress" {
  for_each                     = local.endpoints_sg_ingress_rules
  security_group_id            = aws_security_group.endpoints_sg.id
  from_port                    = each.value.port
  to_port                      = each.value.port
  ip_protocol                  = each.value.protocol
  cidr_ipv4                    = each.value.use_cidr ? each.value.cidr : null
  referenced_security_group_id = each.value.referenced_security_group_id
}
resource "aws_vpc_security_group_egress_rule" "endpoints_sg_egress" {
  for_each                     = local.endpoints_sg_egress_rules
  security_group_id            = aws_security_group.endpoints_sg.id
  from_port                    = each.value.port
  to_port                      = each.value.port
  ip_protocol                  = each.value.protocol
  cidr_ipv4                    = each.value.use_cidr ? each.value.cidr : null
  referenced_security_group_id = each.value.referenced_security_group_id
}