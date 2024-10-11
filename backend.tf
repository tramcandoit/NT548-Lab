terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    region  = "ap-southeast-1"
    bucket  = "terraform-tfstate-s3-bucket-lab1"
    key     = "terraform.tfstate"
    profile = ""
    encrypt = "true"

    dynamodb_table = "terraform-tfstate-lock"
  }
}
