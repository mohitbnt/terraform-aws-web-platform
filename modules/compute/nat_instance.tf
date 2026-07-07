resource "aws_instance" "nat_instance" {
  count         = var.enable_nat_instance ? 1 : 0
  ami           = data.aws_ami.ubuntu24.id
  instance_type = var.nat_instance_config.instance_type
  root_block_device {
    volume_size = var.nat_instance_config.root_volume_size
    volume_type = var.nat_instance_config.root_volume_type
    encrypted   = var.nat_instance_config.root_volume_encrypted
  }
  subnet_id              = var.public_subnet_ids[0]
  source_dest_check      = false
  user_data_base64       = local.nat_user_data
  iam_instance_profile   = var.nat_instance_profile_name
  vpc_security_group_ids = var.nat_security_group_id
  key_name               = aws_key_pair.nat_key_pair[0].key_name
  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-nat-instance"
    }
  )
}