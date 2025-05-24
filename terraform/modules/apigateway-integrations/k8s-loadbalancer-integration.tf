# API Gateway Resource for proxy path
resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = var.api_gateway_id
  parent_id   = var.api_gateway_root_resource_id
  path_part   = "api/{proxy+}"
}

# API Gateway Method for the proxy resource
resource "aws_api_gateway_method" "api_proxy_method" {
  rest_api_id = var.api_gateway_id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = "ANY"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# API Gateway Method for the root resource
resource "aws_api_gateway_method" "root_method" {
  rest_api_id = var.api_gateway_id
  resource_id = var.api_gateway_root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

# HARDCODED: put LoadBalancer name


# Search LoadBalancer by name
data "aws_elb" "k8s_lb" {
  name = var.loadbalancer_name
  dns_name = var.loadbalancer_dns
}


# Proxy integration
resource "aws_api_gateway_integration" "proxy_integration" {
  rest_api_id = var.api_gateway_id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.api_proxy_method.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri = "http://${data.aws_elb.k8s_lb.dns_name}/{proxy}"
  passthrough_behavior    = "WHEN_NO_MATCH"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

# API Gateway Integration for the root resource
resource "aws_api_gateway_integration" "root_integration" {
  rest_api_id = aws_api_gateway_rest_api.fast_food_api.id
  resource_id = aws_api_gateway_rest_api.fast_food_api.root_resource_id
  http_method = aws_api_gateway_method.root_method.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri = "http://${data.aws_elb.k8s_lb.dns_name}/"
  passthrough_behavior    = "WHEN_NO_MATCH"
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.proxy_integration,
    aws_api_gateway_integration.root_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.fast_food_api.id

  lifecycle {
    create_before_destroy = true
  }
}

# API Gateway Stage
resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.fast_food_api.id
  stage_name    = "prod"
}
