output "nat_security_group_id" {
  value = var.enable_nat_instance ? aws_security_group.nat_sg[0].id : null
}
output "ec2_security_group_id" {
  value = aws_security_group.ec2_sg.id
}
output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}
output "endpoint_security_group_id" {
  value = aws_security_group.endpoints_sg.id
}