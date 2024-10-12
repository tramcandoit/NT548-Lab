# provider "aws" {
#   region     = var.region
#   access_key = aws_access_key
#   secret_key = aws_secret_access_key
# }

### Declare the VPC module
module "vpc_module" {
  source              = "./modules/aws_vpc"
  region              = var.region
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}


### Declare the NAT Gateway module
module "nat_gateway_module" {
  source     = "./modules/aws_nat-gateway"
  region     = var.region
  subnet_ids = module.vpc_module.public_subnet_id[0]
}

### Declare the Route table module
module "route_table_module" {
  source             = "./modules/aws_route-tables"
  region             = var.region
  vpc_ids            = module.vpc_module.vpc_id
  igw_ids            = module.vpc_module.igw_id
  nat-gateway_ids    = module.nat_gateway_module.nat_gateway_id
  public_subnet_ids  = module.vpc_module.public_subnet_id[0]
  private_subnet_ids = module.vpc_module.private_subnet_id[0]
}