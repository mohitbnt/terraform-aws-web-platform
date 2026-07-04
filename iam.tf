# IAM Roles
###############################################################
resource "aws_iam_role" "nat_role" {
  name               = "${local.environment}-${local.common_tags.Project}-nat_role"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust_policy.json
  tags = {
    Name = "${local.environment}-${local.common_tags.Project}-nat_role"
  }
}
resource "aws_iam_role" "ec2_role" {
  name               = "${local.environment}-${local.common_tags.Project}-ec2_role"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust_policy.json
  tags = {
    Name = "${local.environment}-${local.common_tags.Project}-ec2_role"
  }
}

# IAM Policy Attachments
###############################################################
resource "aws_iam_role_policy_attachment" "nat_ssm_attachment" {
  role       = aws_iam_role.nat_role.name
  policy_arn = local.ssm_policy_arn
}
resource "aws_iam_role_policy_attachment" "ec2_ssm_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = local.ssm_policy_arn
}

# Instance Profiles
###############################################################
resource "aws_iam_instance_profile" "nat_instance_profile" {
  role = aws_iam_role.nat_role.name
  name = "${local.environment}-${local.common_tags.Project}-nat_instance_profile"
  tags = {
    Name = "${local.environment}-${local.common_tags.Project}-nat_instance_profile"
  }
}
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  role = aws_iam_role.ec2_role.name
  name = "${local.environment}-${local.common_tags.Project}-ec2_instance_profile"
  tags = {
    Name = "${local.environment}-${local.common_tags.Project}-ec2_instance_profile"
  }
}