variable "lambda_arn" {
  type        = string
  description = "ARN of the Lambda to invoke"
}

variable "lambda_invoke_arn" {
  type        = string
  description = "Invoke ARN of the Lambda to invoke"
}

variable "api_env" {
  type        = map(string)
  description = "Environment variables for the API"
}