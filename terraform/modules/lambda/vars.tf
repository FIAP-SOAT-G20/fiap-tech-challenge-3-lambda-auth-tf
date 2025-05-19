variable "vpc_subnet_ids" {
  type        = list(string)
  description = "Subnet IDs of the VPC"
}

variable "vpc_security_group_id" {
  type        = string
  description = "Security group ID of the VPC"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "lambda_env" {
  type        = map(string)
  description = "Environment variables for the Lambda function"
}