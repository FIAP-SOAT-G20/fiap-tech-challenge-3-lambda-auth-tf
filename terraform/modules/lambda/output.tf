output "fastfood_auth_lambda_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.fastfood_auth_lambda.arn
}

output "fastfood_auth_lambda_invoke_arn" {
  description = "The Invoke ARN of the Lambda function"
  value       = aws_lambda_function.fastfood_auth_lambda.invoke_arn
}