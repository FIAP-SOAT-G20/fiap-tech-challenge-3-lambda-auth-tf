resource "aws_api_gateway_rest_api" "fast_food_api" {
  name = "fast-food-auth-api"
  description = "Fast Food Auth API"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "auth_resource" {
  rest_api_id = aws_api_gateway_rest_api.fast_food_api.id
  parent_id = aws_api_gateway_rest_api.fast_food_api.root_resource_id
  path_part = "auth"  
}