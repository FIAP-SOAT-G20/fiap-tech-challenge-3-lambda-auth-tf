resource "aws_lambda_permission" "apigw_lambda" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.fast_food_api.execution_arn}/*/*/*"
}