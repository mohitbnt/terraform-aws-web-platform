# NAT Instance
###############################################################
resource "aws_instance" "nat_instance" {
  ami                    = data.aws_ami.ubuntu24.id
  instance_type          = local.nat.instance_type
  subnet_id              = aws_subnet.public_subnet[0].id
  source_dest_check      = false
  user_data_base64       = local.nat_user_data
  iam_instance_profile   = aws_iam_instance_profile.nat_instance_profile.name
  vpc_security_group_ids = [aws_security_group.nat_sg.id]
  key_name               = var.key_name
  tags = {
    Name = "${local.environment}-${local.common_tags.Project}-nat_instance"
  }
}

# Launch Template
###############################################################
resource "aws_launch_template" "launch_template" {
  name          = "${local.environment}-${local.common_tags.Project}-lt"
  image_id      = data.aws_ami.ubuntu24.id
  instance_type = local.ec2.instance_type
  user_data     = local.ec2_user_data
  key_name      = var.key_name
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  monitoring {
    enabled = true
  }

  block_device_mappings {
    device_name = data.aws_ami.ubuntu24.root_device_name
    ebs {
      volume_size           = local.ec2.ebs_size
      volume_type           = "gp3"
      iops                  = 3000
      throughput            = 125
      delete_on_termination = true
    }
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }
  lifecycle {
    create_before_destroy = true
  }
  update_default_version = true
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Web-Instance"
    }
  }
  tag_specifications {
    resource_type = "volume"
    tags = {
      Name = "Web-EBS"
    }
  }
}

# Auto Scaling Group
###############################################################
resource "aws_autoscaling_group" "web_asg" {
  name                      = "${local.environment}-${local.common_tags.Project}-asg"
  desired_capacity          = var.asg_configuration[local.environment].desired
  min_size                  = var.asg_configuration[local.environment].min
  max_size                  = var.asg_configuration[local.environment].max
  health_check_grace_period = var.asg_configuration[local.environment].grace_period
  protect_from_scale_in     = var.asg_configuration[local.environment].protect_scale_in
  termination_policies      = [var.asg_configuration[local.environment].termination_policy]

  vpc_zone_identifier = aws_subnet.private_subnet[*].id
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = aws_launch_template.launch_template.latest_version
  }
  target_group_arns = [aws_lb_target_group.web_tg.arn]
  health_check_type = "ELB"
  force_delete      = false

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }
  enabled_metrics = [
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  tag {
    key                 = "Name"
    value               = "${local.environment}-asg-instance"
    propagate_at_launch = true
  }
  tag {
    key                 = "Environment"
    value               = local.environment
    propagate_at_launch = true
  }
  tag {
    key                 = "Project"
    value               = local.common_tags.Project
    propagate_at_launch = true
  }
  depends_on = [
    aws_instance.nat_instance
  ]
}
