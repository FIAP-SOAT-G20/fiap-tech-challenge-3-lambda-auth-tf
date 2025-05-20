variable "lambda_env" {
  type        = map(string)
  description = "Environment variables for the Lambda function"
}

variable "api_env" {
  type        = map(string)
  description = "Environment variables for the API"
}
