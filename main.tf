provider "aws" {
  region = var.region  
}

module "terraform_state_backend" {
  source = "./modules/tfstate-backend"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "x.x.x"
  s3_bucket_name = "terraform-tfstate-s3-bucket-lab1"
  dynamodb_table_name = "terraform-tfstate-lock"
  terraform_backend_config_file_path = "."
  terraform_backend_config_file_name = "backend.tf"
  force_destroy                      = true
}


resource "aws_kms_key" "objects" {
  description             = "KMS key is used to encrypt bucket objects"
  deletion_window_in_days = 7
}


module "s3_terraform_tfvar" {
  source = "./modules/s3"
  bucket = "terraform-tfvars-s3-bucket-lab1"
  # Enforce encryption at rest
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.objects.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning = {
    status     = true
  }

  tags = {
    Environment = var.environment
  }
}


# VPC Module
module "vpc" {
  source = "./modules/vpc"
  name = var.vpc_name
  cidr = var.vpc_cidr

  azs                 = var.azs
  private_subnets     = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  public_subnets      = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 8, k + 4)]

  enable_nat_gateway      = true
  create_igw              = true
# VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  vpc_flow_log_iam_role_name            = "vpc-complete-lab1-role"
  vpc_flow_log_iam_role_use_name_prefix = false
  enable_flow_log                       = true
  create_flow_log_cloudwatch_log_group  = true
  create_flow_log_cloudwatch_iam_role   = true
  flow_log_max_aggregation_interval     = 60
}

# Security Groups Module
module "public_ec2_sg" {
  source      = "./modules/security-groups"
  name        = "public-ec2-sg"
  description = "Allow SSH, HTTP, and HTTPS for Public EC2"
  vpc_id      = module.vpc.vpc_id


  # Keep the SSH rule here with a specific IP range
  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = var.allowed_ssh_ip  # Only allow SSH from this IP
    },
    {
      rule = "http-80-tcp",
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule = "https-443-tcp",
      cidr_blocks = "0.0.0.0/0"
    }

  ]

  egress_rules = ["all-all"]  # Allow all outbound traffic

  tags = {
    Environment = var.environment
  }
}

module "private_ec2_sg" {
  source      = "./modules/security-groups"
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
  source = "./modules/key-pair"

  key_name           = var.key_name
  create_private_key = true

   tags = {
    Environment = var.environment
  }
}

# Public EC2 Instance
module "public_ec2" {
  source = "./modules/ec2"
  name = "public-ec2-${var.environment}"
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address  = true
  
  key_name                    = var.key_name
  vpc_security_group_ids       = [module.public_ec2_sg.security_group_id]  # Apply the Public EC2 SG
}

# Private EC2 Instance
module "private_ec2" {
  source = "./modules/ec2"
  name = "private-ec2-${var.environment}"
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.private_subnets[0]
  associate_public_ip_address  = false
  key_name                    = var.key_name
  vpc_security_group_ids       = [module.private_ec2_sg.security_group_id]  # Apply the Private EC2 SG
}
