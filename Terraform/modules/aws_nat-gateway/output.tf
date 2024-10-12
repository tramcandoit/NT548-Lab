# Output the NAT Gateway ID
output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.natgw.id
}

# # Output the Elastic IP ID associated with the NAT Gateway
# output "nat_eip_id" {
#   description = "The Elastic IP ID associated with the NAT Gateway"
#   value       = aws_eip.nat_eip.id
# }