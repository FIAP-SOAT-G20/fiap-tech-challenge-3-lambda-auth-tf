// allow lambda service to assume (use) the role with such policy
data "aws_iam_policy_document" "assume_lambda_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type = "Service"
    }
  }
}

// create lambda role, that lambda function can assume
resource "aws_iam_role" "lambda" {
  name = "AssumeLambdaRole"
  description = "Role for lambda to assume role"
  assume_role_policy = jsonencode(jsondecode(data.aws_iam_policy_document.assume_lambda_role.json))
}

// create a policy to allow writing into logs and create logs stream
data "aws_iam_policy_document" "allow_lambda_logging" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

// attach policy to our created lambda role
resource "aws_iam_policy" "function_logging_policy" {
  name = "AllowLambdaLoggingPolicy"
  description = "Policy for lambda cloudwatch logs"
  policy = jsonencode(jsondecode(data.aws_iam_policy_document.allow_lambda_logging.json))
}

// attach the logging policy to the lambda role
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.function_logging_policy.arn
}

