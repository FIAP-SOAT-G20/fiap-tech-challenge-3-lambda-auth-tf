resource "aws_lambda_function" "fastfood_auth_lambda" {
  function_name = "fastfood-auth"
  runtime       = "provided.al2023"
  handler       = "bootstrap"
  role          = data.aws_iam_role.lambda_exec.arn

  s3_bucket = aws_s3_bucket.lambda_artifacts.id
  s3_key    = aws_s3_object.lambda_zip.key

  memory_size      = 128
  timeout          = 5
  publish          = true
  source_code_hash = filesha256(local.lambda_zip_path)

  environment {
    variables = local.merged_env
  }
}

