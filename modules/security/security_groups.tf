# Security Groups
###############################################################
resource "aws_security_group" "nat_sg" {
  count       = var.enable_nat_instance ? 1 : 0
  name        = "${var.environment}-${var.project_name}-nat-sg"
  description = "Security group for NAT instance"
  vpc_id      = var.vpc_id
  tags = merge(var.common_tags,
    {
      Name = "${var.environment}-${var.project_name}-nat-sg"
    }
  )
}
resource "aws_security_group" "ec2_sg" {
  name        = "${var.environment}-${var.project_name}-ec2-sg"
  description = "Security group for Auto Scaling Group instances"
  vpc_id      = var.vpc_id
  tags = merge(var.common_tags,
    {
      Name = "${var.environment}-${var.project_name}-ec2-sg"
    }
  )
}
resource "aws_security_group" "alb_sg" {
  name        = "${var.environment}-${var.project_name}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id
  tags = merge(var.common_tags,
    {
      Name = "${var.environment}-${var.project_name}-alb-sg"
    }
  )
}
resource "aws_security_group" "endpoints_sg" {
  name        = "${var.environment}-${var.project_name}-endpoints-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = var.vpc_id
  tags = merge(var.common_tags,
    {
      Name = "${var.environment}-${var.project_name}-endpoints-sg"
    }
  )
}