output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main_vpc.id
}
output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public_rt.id
}
output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = aws_route_table.private_rt.id
}
output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}
output "public_subnet_ids" {
  description = "List of IDs of public subnets."
  value       = aws_subnet.public_subnet[*].id
}
output "private_subnet_ids" {
  description = "List of IDs of private subnets."
  value       = aws_subnet.private_subnet[*].id
}