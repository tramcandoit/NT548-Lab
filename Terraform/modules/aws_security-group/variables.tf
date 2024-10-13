variable "region" {
  type        = string
  default     = "ap-southeast-1"
  description = "Region of Security Group"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
  default     = "vpc-0f889d850ad3bb664"
}

### Must specify the exact ip address that has permission to access the EC2 instance in public subnet
variable "cidr_block" {
  description = "Public IP from Internet that has permission to access the EC2 instance in public subnet"
  type        = string
  default     = "18.139.24.244/32"
}