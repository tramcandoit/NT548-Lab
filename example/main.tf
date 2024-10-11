provider "aws" {
  region = var.region  
}

# VPC Module
module "vpc" {
  source = "../modules/vpc"
  name = var.vpc_name
  cidr = var.vpc_cidr

  azs                 = var.azs
  private_subnets     = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  public_subnets      = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 8, k + 4)]

  enable_nat_gateway      = true
  create_igw              = true
# VPC Flow Logs 
  vpc_flow_log_iam_role_name            = "vpc-complete-lab1-role"
  vpc_flow_log_iam_role_use_name_prefix = false
  enable_flow_log                       = true
  create_flow_log_cloudwatch_log_group  = true
  create_flow_log_cloudwatch_iam_role   = true
  flow_log_max_aggregation_interval     = 60
}

# Security Groups Module
module "public_ec2_sg" {
  source      = "../modules/security-groups"
  name        = "public-ec2-sg"
  description = "Allow SSH, HTTP, and HTTPS for Public EC2"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [var.allowed_ssh_ip]  

  ingress_rules = ["https-443-tcp", "http-80-tcp"]

  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = var.allowed_ssh_ip  
    }
  ]

  egress_rules = ["all-all"] 

  tags = {
    Environment = var.environment
  }
}

module "private_ec2_sg" {
  source      = "../modules/security-groups"
  name        = "private-ec2-sg"
  description = "Allow SSH from Public EC2"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "ssh-tcp"
      source_security_group_id = module.public_ec2_sg.security_group_id  # Only allow SSH from Public EC2 SG
    }
  ]

  egress_rules = ["all-all"]  # Allow all outbound traffic

  tags = {
    Environment = var.environment
  }
}

# Create key pair
module "key_pair" {
  source = "../modules/key-pair"

  key_name           = var.key_name
  create_private_key = true

   tags = {
    Environment = var.environment
  }
}

# Public EC2 Instance
module "public_ec2" {
  source = "../modules/ec2"
  name = "public-ec2-${var.enviroment}"
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address  = true
  
  key_name                    = var.key_name
  vpc_security_group_ids       = [module.public_ec2_sg.security_group_id]  # Apply the Public EC2 SG
}

# Private EC2 Instance
module "private_ec2" {
  source = "../modules/ec2"
  name = "private-ec2-${var.enviroment}"
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.private_subnets[0]
  associate_public_ip_address  = false
  key_name                    = var.key_name
  vpc_security_group_ids       = [module.private_ec2_sg.security_group_id]  # Apply the Private EC2 SG
}
