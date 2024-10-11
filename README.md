# Terraform AWS NT548.P11 Deployment

This is practice lab of NT548.P11 subject that require using Terraform to deploy essential AWS services, including a Virtual Private Cloud (VPC), subnets, Internet Gateways, NAT Gateways, EC2 instances, and Security Groups, all structured as modules for modularity and reusability.

## Overview of Services

1. **VPC**
   - Creates a VPC containing:
     - **Subnets**
       - Public Subnet (connected to an Internet Gateway)
       - Private Subnet (uses a NAT Gateway for outbound internet access)
     - **Internet Gateway**: Connects to the Public Subnet to enable internet access for resources.
     - **Default Security Group**: Creates a default security group for the VPC.

2. **Route Tables**
   - Creates Route Tables for both Public and Private Subnets:
     - **Public Route Table**: Routes internet traffic through the Internet Gateway.
     - **Private Route Table**: Routes internet traffic through the NAT Gateway.

3. **NAT Gateway**
   - Enables resources in the Private Subnet to connect to the internet while maintaining security.

4. **EC2 Instances**
   - Launches EC2 instances in both Public and Private Subnets:
     - **Public EC2 Instance**: Accessible from the internet.
     - **Private EC2 Instance**: Accessible only from the Public EC2 instance via SSH or other secure methods.

5. **Security Groups**
   - Creates Security Groups to control traffic in and out of EC2 instances:
     - **Public EC2 Security Group**: Allows SSH (port 22) connections from a specific IP.
     - **Private EC2 Security Group**: Allows connections from the Public EC2 instance through necessary ports.

## Requirements

- Terraform version 1.x
- AWS Account with appropriate permissions

## Getting Started

### Clone the Repository

```bash
git clone https://github.com/tdmidas/NT548-Lab1-Terraform.git
cd NT548-Lab1-Terraform
```
### Initialize Terraform

```bash
terraform init
```

### Plan the Deployment

```bash
terraform plan
```
### Apply the Configuration

```bash
terraform apply --auto-approve
```

### Move Terraform state to S3 bucket
This concludes the one-time preparation. Now you can extend and modify your Terraform configuration as usual.

```bash
terraform init -force-copy
```

### Clean up resources

```bash
terraform destroy
```

