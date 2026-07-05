locals {
  az_count     = length(var.public_subnet_cidrs)
  selected_azs = slice(data.aws_availability_zones.azs.names, 0, local.az_count)
}