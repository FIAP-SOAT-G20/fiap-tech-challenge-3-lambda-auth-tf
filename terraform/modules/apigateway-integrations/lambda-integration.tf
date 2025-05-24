resource "aws_api_gateway_resource" "auth_resource" {
  rest_api_id = var.api_gateway_id
  parent_id = var.api_gateway_root_resource_id
  path_part = "auth"  
}

resource "aws_api_gateway_method" "auth_proxy_method" {
  rest_api_id = var.api_gateway_id
  resource_id = aws_api_gateway_resource.auth_resource.id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = var.api_gateway_id
  resource_id = aws_api_gateway_resource.auth_resource.id
  http_method = aws_api_gateway_method.auth_proxy_method.http_method
  integration_http_method = "POST"
  type = "AWS"
  uri = var.lambda_arn
}

resource "aws_api_gateway_method_response" "auth_proxy_method" {
  rest_api_id = var.api_gateway_id
  resource_id = aws_api_gateway_resource.auth_resource.id
  http_method = aws_api_gateway_method.auth_proxy_method.http_method
  status_code = "200"

  //cors section
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "auth_proxy_method" {
  rest_api_id = var.api_gateway_id
  resource_id = aws_api_gateway_resource.auth_resource.id
  http_method = aws_api_gateway_method.auth_proxy_method.http_method
  status_code = aws_api_gateway_method_response.auth_proxy_method.status_code

  depends_on = [
    aws_api_gateway_method.auth_proxy_method,
    aws_api_gateway_integration.lambda_integration
  ]
}