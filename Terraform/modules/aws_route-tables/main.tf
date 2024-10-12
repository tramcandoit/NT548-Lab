provider "aws" {
    region = var.region
}

locals {
    project_name = "lab1-group13"
}

#---------------------------------------------------------------#
#------------------ Create Public Route Table ------------------#
#------------------------ Route to IGW -------------------------#
#---------------------------------------------------------------#

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0" # Destination cidr block
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${project_name}-public_rtb"
  }
}

#---------------------------------------------------------------#
#------------------ Create Private Route Table -----------------#
#----------------------- Route to NATGW ------------------------#
#---------------------------------------------------------------#

resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"                
    nat_gateway_id = aws_nat_gateway.natgw.id  
  }

  tags = {
    Name = "${project_name}-private_rtb"
  }
}

#---------------------------------------------------------------#
#----------------- Associate Public Route Table ----------------#
#--------------------- to public Subnet ------------------------#
#---------------------------------------------------------------#

resource "aws_route_table_association" "public_rtb_asso" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rtb.id
}

#---------------------------------------------------------------#
#---------------- Associate Private Route Table ----------------#
#--------------------- to private Subnet -----------------------#
#---------------------------------------------------------------#

resource "aws_route_table_association" "private_rtb_asso" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rtb.id
}