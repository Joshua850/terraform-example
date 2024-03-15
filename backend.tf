terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.18.0"
    }
  }

  backend "s3" {
    bucket  = "my-s3-bucket"
    key     = "state/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}