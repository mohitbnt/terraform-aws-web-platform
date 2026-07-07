# IAM Roles
###############################################################
resource "aws_iam_role" "nat_role" {
  count              = var.enable_nat_instance ? 1 : 0
  name               = "${var.environment}-${var.project_name}-nat-role"
  assume_role_policy = data.aws_iam_policy_document.instance_trust_policy.json
  tags = merge(var.common_tags,
    {
      Name = "${var.environment}-${var.project_name}-nat-role"
    }
  )
}
resource "aws_iam_role" "ec2_role" {
  name               = "${var.environment}-${var.project_name}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.instance_trust_policy.json
  tags = merge(var.common_tags,
    {
      Name = "${var.environment}-${var.project_name}-ec2-role"
    }
  )
}

# IAM Policy Attachments
###############################################################
resource "aws_iam_role_policy_attachment" "nat_ssm_attachment" {
  count      = var.enable_nat_instance ? 1 : 0
  role       = aws_iam_role.nat_role[0].name
  policy_arn = local.ssm_policy_arn
}
resource "aws_iam_role_policy_attachment" "ec2_ssm_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = local.ssm_policy_arn
}

# Instance Profiles
###############################################################
resource "aws_iam_instance_profile" "nat_instance_profile" {
  count = var.enable_nat_instance ? 1 : 0
  role  = aws_iam_role.nat_role[0].name
  name  = "${var.environment}-${var.project_name}-nat-instance-profile"
  tags = merge(var.common_tags,
    {
      Name = "${var.environment}-${var.project_name}-nat-instance-profile"
    }
  )
}
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  role = aws_iam_role.ec2_role.name
  name = "${var.environment}-${var.project_name}-ec2-instance-profile"
  tags = merge(var.common_tags,
    {
      Name = "${var.environment}-${var.project_name}-ec2-instance-profile"
    }
  )
}