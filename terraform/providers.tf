provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project = "fastfood-auth-g22-tc3"
      Environment = "production"
    }
  }
}