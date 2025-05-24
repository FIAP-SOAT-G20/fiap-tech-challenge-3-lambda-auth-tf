variable "lambda_env" {
  type        = map(string)
  description = "Environment variables for the Lambda function"
}

variable "api_env" {
  type        = map(string)
  description = "Environment variables for the API"
}

variable "bucket_remote_state" {
  type        = string
  description = "Bucket name for the remote state"
}

variable "key_k8s_remote_state" {
  type        = string
  description = "Key name for the remote state"
}

variable "key_db_remote_state" {
  type        = string
  description = "Key name for the remote state"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "loadbalancer_dns" {
  type        = string
  description = "DNS of the LoadBalancer"
}

variable "loadbalancer_name" {
  type        = string
  description = "Name of the LoadBalancer"
}