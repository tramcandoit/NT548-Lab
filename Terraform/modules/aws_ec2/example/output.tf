# output "instance_ids" {
#   description = "The IDs of the EC2 instances created"
#   value       = [for instance in aws_instance.ec2-instance : instance.id]
# }

# output "instance_public_ips" {
#   description = "The public IPs of the EC2 instances, if associated"
#   value       = [for instance in aws_instance.ec2-instance : instance.public_ip if instance.associate_public_ip_address]
# }

# output "elastic_ip_addresses" {
#   description = "The Elastic IPs associated with the EC2 instances"
#   value       = [for eip in aws_eip.elastic_ips : eip.public_ip]
# }

# output "instance_tags" {
#   description = "Tags of the EC2 instances"
#   value       = { for instance in aws_instance.ec2-instance : instance.id => instance.tags }
# }

# output "instance_details" {
#   description = "Detailed information about each EC2 instance"
#   value       = { for instance in aws_instance.ec2-instance : instance.id => {
#     ami                 = instance.ami
#     instance_type      = instance.instance_type
#     public_ip          = instance.public_ip
#     private_ip         = instance.private_ip
#     tags               = instance.tags
#     root_block_device  = instance.root_block_device
#   }}
# }

# output "eip_associations" {
#   description = "Associations of Elastic IPs to EC2 instances"
#   value       = { for association in aws_eip_association.eip_association : association.instance_id => association.allocation_id }
# }