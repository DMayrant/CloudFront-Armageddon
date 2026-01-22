terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.27"
    }
  }
}

provider "aws" {
  alias  = "use1"
  region = "us-east-1"
}

