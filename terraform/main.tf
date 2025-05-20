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
    bucket         = "fastfood-terraform-state-g22-tc3"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
    encrypt        = true
  }
}

module "vpc" {
  source = "./modules/vpc"
}

module "lambda_function" {
  source = "./modules/lambda"
  depends_on = [module.vpc]
  vpc_id = module.vpc.fastfood_vpc_id
  vpc_subnet_ids = module.vpc.fastfood_vpc_subnet_ids
  vpc_security_group_id = module.vpc.fastfood_vpc_security_group_id  
  lambda_env = var.lambda_env
} 

module "apigateway" {
  source = "./modules/apigateway"
  depends_on = [module.lambda_function]
  lambda_arn = module.lambda_function.fastfood_auth_lambda_arn
  lambda_invoke_arn = module.lambda_function.fastfood_auth_lambda_invoke_arn
  api_env = var.api_env
}