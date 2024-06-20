terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 4.0"
    }
  }

  backend "s3" {
    bucket = "greg-tf-state"
    key = "prod/terraform.tfstate"
    region = "eu-west-2"
    dynamodb_table = "greg-terraform-dyndb-table"
    encrypt = true
    
  }
}

provider "aws" {
  region = "eu-west-2"
}