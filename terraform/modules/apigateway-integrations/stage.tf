resource "aws_api_gateway_stage" "auth_stage" {
  deployment_id = aws_api_gateway_deployment.auth_deployment.id
  rest_api_id   = var.api_gateway_id
  stage_name    = "prod"
}

resource "aws_api_gateway_stage" "api_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = var.api_gateway_id
  stage_name    = "prod"
}
