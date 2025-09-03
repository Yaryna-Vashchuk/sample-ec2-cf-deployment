terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 6.4.0"
    }
  }

  backend "s3" {
    bucket = "infra-state-bucket-030925"
    key = "global.tfstate"
    region = "eu-west-1"
    dynamodb_table = "tf-state-lock"
    encrypt = true
  }
}