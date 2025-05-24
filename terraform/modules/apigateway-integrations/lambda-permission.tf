resource "aws_lambda_permission" "apigw_lambda" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal = "apigateway.amazonaws.com"

  source_arn = "${var.api_gateway_invoke_arn}/*/*/*"
}