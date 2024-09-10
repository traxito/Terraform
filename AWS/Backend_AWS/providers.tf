terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.64.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region     = "eu-central-1"
  access_key = "XXXXXXXXXXXXXXXXXXXX"
  secret_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
}