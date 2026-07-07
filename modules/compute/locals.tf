locals {
  nat_user_data = base64encode(templatefile("${path.module}/templates/nat_instance_userdata.tftpl", {}))
  ec2_user_data = base64encode(templatefile("${path.module}/templates/nginx.tftpl", {
    asg_name    = "Web_ASG"
    environment = var.environment
  }))
}