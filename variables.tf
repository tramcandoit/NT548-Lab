# variables.tf

variable "region" {
  description = "The AWS region to deploy resources."
  type        = string
}
variable "vpc_name" {
  description = "The name of the VPC."
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "azs" {
  description = "The availability zones for the VPC."
  type        = list(string)
}
variable "allowed_ssh_ip" {
  description = "The IP address allowed to SSH into the EC2 instances."
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., dev, prod)."
  type        = string
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instances."
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type."
  type        = string
}

variable "key_name" {
  description = "The name of the key pair to use for the EC2 instances."
  type        = string
}

