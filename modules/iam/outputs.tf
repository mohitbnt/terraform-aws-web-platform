output "nat_instance_profile_name" {
  description = "Instance profile name for NAT instance."
  value = try(
    aws_iam_instance_profile.nat_instance_profile[0].name,
    null
  )
}
output "ec2_instance_profile_name" {
  description = "Instance profile name for application instances."
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}

