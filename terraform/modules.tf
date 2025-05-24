
module "api_gateway" {
  source = "./modules/apigateway"
}

module "security_group" {
  source = "./modules/security-group"
  vpc_id = data.terraform_remote_state.k8s.outputs.vpc_id
}

module "lambda_function" {
  source = "./modules/lambda"
  depends_on = [module.api_gateway]
  
  # From vars.tf
  lambda_env = var.lambda_env

  # From tf-remote-k8s.tf
  vpc_subnet_ids = data.terraform_remote_state.k8s.outputs.subnet_ids
  vpc_security_group_id = module.security_group.security_group_id 
  db_host = data.terraform_remote_state.db.outputs.rds_endpoint
} 

module "api_gateway_integrations" {
  source = "./modules/apigateway-integrations"
  depends_on = [module.api_gateway, module.lambda_function]

  # From modules/apigateway/output.tf
  api_gateway_id = module.api_gateway.api_gateway_id
  api_gateway_root_resource_id = module.api_gateway.api_gateway_root_resource_id
  api_gateway_invoke_arn = module.api_gateway.api_gateway_invoke_arn

  # From modules/lambda/output.tf
  lambda_arn = module.lambda_function.fastfood_auth_lambda_arn

  # From vars.tf
  loadbalancer_name = var.loadbalancer_name
  loadbalancer_dns = var.loadbalancer_dns
}