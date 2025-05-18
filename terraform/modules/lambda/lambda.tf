resource "aws_lambda_function" "fastfood_auth_lambda" {
  function_name = "fastfood-auth"
  runtime       = "go1.x"
  handler       = "bootstrap"               # binary’s filename
  role          = data.aws_iam_role.lambda_exec.arn

  s3_bucket = aws_s3_bucket.lambda_artifacts.id
  s3_key    = aws_s3_object.lambda_zip.key

  memory_size      = 128
  timeout          = 5
  publish          = true              # creates new versions automatically
  source_code_hash = filesha256(local.lambda_zip_path) # forces update on change
}

