resource "aws_launch_template" "launch_template" {
  name          = "${var.environment}-${var.project_name}-lt"
  image_id      = data.aws_ami.ubuntu24.id
  instance_type = var.application_config.instance_type
  user_data     = local.ec2_user_data
  key_name      = aws_key_pair.app_key_pair.key_name
  iam_instance_profile {
    name = var.ec2_instance_profile_name
  }
  vpc_security_group_ids = var.ec2_security_group_id
  monitoring {
    enabled = true
  }

  block_device_mappings {
    device_name = data.aws_ami.ubuntu24.root_device_name
    ebs {
      volume_size           = var.application_config.root_volume_size
      volume_type           = var.application_config.root_volume_type
      iops                  = 3000
      throughput            = 125
      delete_on_termination = true
      encrypted             = var.application_config.root_volume_encrypted
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
    tags = merge(var.common_tags, {
      Name = "Web-Instance"
      }
    )
  }
  tag_specifications {
    resource_type = "volume"
    tags = merge(var.common_tags, {
      Name = "Web-EBS"
      }
    )
  }
}