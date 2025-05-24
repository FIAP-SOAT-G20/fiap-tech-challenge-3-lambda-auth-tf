terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source = "hashicorp/archive"
    }
    null = {
      source = "hashicorp/null"
    }
  }

  # used to store the terraformstate file in s3
  backend "s3" {
    bucket         = "fast-food-terraform-state-g22-tc3"
    key            = "fiap/lambda/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
    encrypt        = true
  }
}
