output "nat_instance_primary_eni_id" {
  description = "Primaty Interface ID of NAT instance"
  value = try(
    aws_instance.nat_instance[0].primary_network_interface_id,
    null
  )
}