# Output the VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc_module.vpc_id
}

# Output the Public Subnet IDs
output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = module.vpc_module.public_subnet_id
}

# Output the Private Subnet IDs
output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = module.vpc_module.private_subnet_id
}

# Output the Internet Gateway ID
output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc_module.igw_id
}

# # Output the Security Group ID
# output "default_security_group_id" {
#   description = "The ID of the default security group"
#   value       = aws_default_security_group.default-sg.id
# }

# Output the VPC CIDR block
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc_module.vpc_cidr_block
}

# Output the CIDR blocks for the subnets
output "public_subnet_cidr" {
  description = "The CIDR block of the public subnet"
  value       = module.vpc_module.public_subnet_cidr
}

output "private_subnet_cidr" {
  description = "The CIDR block of the private subnet"
  value       = module.vpc_module.private_subnet_cidr
}

# Output the NAT Gateway ID
output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = module.nat_gateway_module.nat_gateway_id
}

# # Output the Elastic IP ID associated with the NAT Gateway
# output "nat_eip_id" {
#   description = "The Elastic IP ID associated with the NAT Gateway"
#   value       = aws_eip.nat_eip.id
# }

# Output the Public Route Table ID
output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = module.route_table_module.public_route_table_id
}

# Output the Private Route Table ID
output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = module.route_table_module.private_route_table_id
}