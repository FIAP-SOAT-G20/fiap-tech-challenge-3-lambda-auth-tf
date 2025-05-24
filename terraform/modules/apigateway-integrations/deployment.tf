resource "aws_api_gateway_deployment" "auth_deployment" {
  depends_on = [
    aws_api_gateway_resource.auth_resource,
    aws_api_gateway_method.auth_proxy_method,
    aws_api_gateway_integration.lambda_integration,
    aws_api_gateway_method_response.auth_proxy_method,
    aws_api_gateway_integration_response.auth_proxy_method,
  ]

  rest_api_id = var.api_gateway_id  

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.auth_resource.id,
      aws_api_gateway_method.auth_proxy_method.id,
      aws_api_gateway_integration.lambda_integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_resource.api_resource,
    aws_api_gateway_method.api_method,
    aws_api_gateway_resource.api_proxy_resource,
    aws_api_gateway_method.api_proxy_method,
    aws_api_gateway_integration.root_integration,
    aws_api_gateway_integration.api_integration,
  ]

  rest_api_id = var.api_gateway_id  

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.api_resource.id,
      aws_api_gateway_method.api_proxy_method.id,
      aws_api_gateway_integration.api_integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}
