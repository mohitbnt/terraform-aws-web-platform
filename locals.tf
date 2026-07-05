locals {
  environment = var.environment
  #  bucket_name   = "terraform-backend-${data.aws_caller_identity.current.account_id}"
  project_name = "terraform-nginx"
  common_tags = {
    Project      = local.project_name
    project_name = local.project_name
    Environment  = local.environment
    ManagedBy    = "Terraform"
  }


  # VPC Interface Enpoints locals
  ##########################################################################################
  interface_endpoints = {
    ssm         = "com.amazonaws.${var.aws_region}.ssm"
    ssmmessages = "com.amazonaws.${var.aws_region}.ssmmessages"
    ec2messages = "com.amazonaws.${var.aws_region}.ec2messages"
  }

  # IAM Policy ARNs
  ##########################################################################################
  ssm_policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

  # NAT Userata and local
  ##########################################################################################
  nat_user_data = base64encode(templatefile("${path.module}/userdata/nat_instance_userdata.tftpl", {}))
  nat = {
    instance_type = "t3.micro"
    ebs_size      = 8
  }

  # EC2 Userdata and local
  ##########################################################################################
  ec2_user_data = base64encode(templatefile("${path.module}/userdata/nginx.tftpl", {
    asg_name    = "WEB_ASG"
    environment = local.environment
  }))

  ec2 = {
    instance_type = "t3.micro"
    ebs_size      = 20
  }
  website_dns_records = [var.domain_name, "www.${var.domain_name}"]
}
