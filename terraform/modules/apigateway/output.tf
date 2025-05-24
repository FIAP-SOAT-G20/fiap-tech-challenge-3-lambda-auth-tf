output "api_gateway_id" {
  description = "The ID of the API Gateway"
  value       = aws_api_gateway_rest_api.fast_food_api.id
}

output "api_gateway_root_resource_id" {
  description = "The root resource ID of the API Gateway"
  value       = aws_api_gateway_rest_api.fast_food_api.root_resource_id
}

output "api_gateway_invoke_arn" {
  description = "The invoke ARN of the API Gateway"
  value       = aws_api_gateway_rest_api.fast_food_api.execution_arn
}