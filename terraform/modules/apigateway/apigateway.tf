resource "aws_api_gateway_rest_api" "fast_food_api" {
  name = "fast-food-auth-api"
  description = "Fast Food Auth API"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}