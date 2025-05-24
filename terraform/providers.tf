provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project = "fastfood-auth-g22-tc3"
      Environment = var.lambda_env.ENVIRONMENT
    }
  }
}