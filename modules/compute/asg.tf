resource "aws_autoscaling_group" "web_asg" {
  name                      = "${var.environment}-${var.project_name}-asg"
  desired_capacity          = var.application_config.desired_capacity
  min_size                  = var.application_config.min_size
  max_size                  = var.application_config.max_size
  health_check_grace_period = var.application_config.health_check_grace_period
  protect_from_scale_in     = var.application_config.protect_scale_in
  termination_policies      = var.application_config.termination_policy

  vpc_zone_identifier = var.private_subnet_ids
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = aws_launch_template.launch_template.latest_version
  }
  target_group_arns = var.target_group_arns
  health_check_type = var.application_config.health_check_type
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
    value               = "${var.environment}-${var.project_name}-app"
    propagate_at_launch = true
  }
  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
  tag {
    key                 = "Project"
    value               = var.project_name
    propagate_at_launch = true
  }
}
