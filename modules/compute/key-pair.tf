# SSH Key Generation
###############################################################

resource "tls_private_key" "app_ssh_key" {
  algorithm = "ED25519"
}

resource "tls_private_key" "nat_ssh_key" {
  count     = var.enable_nat_instance ? 1 : 0
  algorithm = "ED25519"
}


# Private Key Files
###############################################################

resource "local_file" "app_private_key_file" {
  content         = tls_private_key.app_ssh_key.private_key_openssh
  filename        = "${path.root}/generated/${var.environment}-${var.project_name}-app.pem"
  file_permission = "0600"
}

resource "local_file" "nat_private_key_file" {
  count           = var.enable_nat_instance ? 1 : 0
  content         = tls_private_key.nat_ssh_key[0].private_key_openssh
  filename        = "${path.root}/generated/${var.environment}-${var.project_name}-nat.pem"
  file_permission = "0600"
}

# AWS Key Pairs
###############################################################

resource "aws_key_pair" "app_key_pair" {
  key_name   = "${var.environment}-${var.project_name}-app-ssh-key"
  public_key = tls_private_key.app_ssh_key.public_key_openssh

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-app-ssh-key"
  })
}

resource "aws_key_pair" "nat_key_pair" {
  count      = var.enable_nat_instance ? 1 : 0
  key_name   = "${var.environment}-${var.project_name}-nat-ssh-key"
  public_key = tls_private_key.nat_ssh_key[0].public_key_openssh

  tags = merge(var.common_tags, {
    Name = "${var.environment}-${var.project_name}-nat-ssh-key"
  })
}