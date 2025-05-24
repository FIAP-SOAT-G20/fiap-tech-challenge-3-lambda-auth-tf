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
    key            = "fiap/lambda/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
    encrypt        = true
  }
}

module "lambda_function" {
  source = "./modules/lambda"
  depends_on = [module.vpc]
  vpc_id = data.terraform_remote_state.k8s.outputs.vpc_id
  vpc_subnet_ids = data.terraform_remote_state.k8s.outputs.subnet_ids
  vpc_security_group_id = data.terraform_remote_state.k8s.outputs.security_group_id  
  lambda_env = var.lambda_env
  api_gateway_id = data.terraform_remote_state.k8s.outputs.api_gateway_id
  api_gateway_root_resource_id = data.terraform_remote_state.k8s.outputs.api_gateway_root_resource_id
} 