# Ingress and Egress rules
###############################################################
# For NAT SG
resource "aws_vpc_security_group_ingress_rule" "nat_sg_ingress" {
  for_each                     = var.enable_nat_instance ? local.nat_sg_ingress_rules : {}
  security_group_id            = aws_security_group.nat_sg[0].id
  from_port                    = each.value.port
  to_port                      = each.value.port
  ip_protocol                  = each.value.protocol
  cidr_ipv4                    = each.value.use_cidr ? each.value.cidr : null
  referenced_security_group_id = each.value.referenced_security_group_id
}
resource "aws_vpc_security_group_egress_rule" "nat_sg_egress" {
  for_each                     = var.enable_nat_instance ? local.nat_sg_egress_rules : {}
  security_group_id            = aws_security_group.nat_sg[0].id
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