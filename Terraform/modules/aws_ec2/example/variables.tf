variable "region" {
  type        = string
  default     = "ap-southeast-1"
  description = "Region of EC2"
}

variable "instances_configuration" {
  type = list(object({
    count         = number
    ami           = string
    instance_type = string
    root_block_device = object({
      volume_size = number
      volume_type = string
    })
    tags                   = map(string)
    vpc_security_group_ids = list(string)
    subnet_id              = string
    user_data_file         = optional(string, null) #path to user_data file
    key_name               = string
    associate_elastic_ip   = bool
    iam_instance_profile   = optional(string, null) # instance in private subnet does not need public IP
  }))

  default = [{
    count         = 1
    ami           = "ami-03fa85deedfcac80b" # ubuntu 22.04
    instance_type = "t2.micro"
    root_block_device = {
      volume_size = 8
      volume_type = "gp2"
    }
    tags = {
      Name = "public-instance"
    }
    vpc_security_group_ids = ["sg-0b16f3768e5545259"] # public ssh sg
    subnet_id              = "subnet-0e090222e96132976" # public subnet
    user_data_file         = "user-data.sh"
    key_name               = "lab1-group13-keypair-1"
    associate_elastic_ip   = true
    iam_instance_profile   = "ec2-role-instance-profile"
    },
    {
      count         = 1
      ami           = "ami-03fa85deedfcac80b" # ubuntu 22.04
      instance_type = "t2.micro"
      root_block_device = {
        volume_size = 8
        volume_type = "gp2"
      }
      tags = {
        Name = "private-instance"
      }
      vpc_security_group_ids = ["sg-03e3186c5ad1726f7"] # private ssh sg
      subnet_id              = "subnet-04cf1cd0785d0f1f7" # private subnet
      user_data_file = null
      key_name               = "lab1-group13-keypair-1"
      associate_elastic_ip   = false
      iam_instance_profile = null
  }]
}