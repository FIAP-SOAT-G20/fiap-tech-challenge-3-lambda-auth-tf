variable "api_gateway_invoke_arn" {
  type        = string
  description = "Invoke ARN of the API Gateway"
}

variable "api_gateway_root_resource_id" {
  type        = string
  description = "Root resource ID of the API Gateway"
}

variable "api_gateway_id" {
  type        = string
  description = "ID of the API Gateway"
}

variable "lambda_invoke_arn" {
  type        = string
  description = "Invoke ARN of the Lambda function"
}

variable "loadbalancer_name" {
  type        = string
  description = "Name of the LoadBalancer"
}

variable "loadbalancer_dns" {
  type        = string
  description = "DNS of the LoadBalancer"
}