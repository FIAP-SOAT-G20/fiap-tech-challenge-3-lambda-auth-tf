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
}

module "lambda_function" {
  source = "./modules/lambda"
} 

module "apigateway" {
  source = "./modules/apigateway"
  depends_on = [module.lambda_function]
  lambda_arn = module.lambda_function.fastfood_auth_lambda_arn
  lambda_invoke_arn = module.lambda_function.fastfood_auth_lambda_invoke_arn
}