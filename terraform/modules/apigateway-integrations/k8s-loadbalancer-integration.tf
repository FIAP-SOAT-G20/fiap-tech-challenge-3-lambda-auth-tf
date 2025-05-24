# API Gateway Resource for proxy path
resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = var.api_gateway_id
  parent_id   = var.api_gateway_root_resource_id
  path_part   = "api"
}

resource "aws_api_gateway_resource" "api_proxy_resource" {
  rest_api_id = var.api_gateway_id
  parent_id   = aws_api_gateway_resource.api_resource.id
  path_part   = "{proxy+}"
}

# API Gateway Method for the proxy resource
resource "aws_api_gateway_method" "api_proxy_method" {
  rest_api_id   = var.api_gateway_id
  resource_id   = aws_api_gateway_resource.api_proxy_resource.id
  http_method   = "ANY"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# Proxy integration
resource "aws_api_gateway_integration" "api_integration" {
  rest_api_id = var.api_gateway_id
  resource_id = aws_api_gateway_resource.api_proxy_resource.id
  http_method = aws_api_gateway_method.api_proxy_method.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri = "http://${var.loadbalancer_dns}/api/{proxy}"
  passthrough_behavior    = "WHEN_NO_MATCH"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

# API Gateway Integration for the root resource
resource "aws_api_gateway_integration" "root_integration" {
  rest_api_id = var.api_gateway_id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.api_proxy_method.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri = "http://${var.loadbalancer_dns}/"
  passthrough_behavior    = "WHEN_NO_MATCH"
}
