
resource "aws_s3_bucket" "lambda_artifacts" {
  bucket = "fast-food-lambda-artifacts-g22-tc3"
}

resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.lambda_artifacts.id
  key    = "${filesha256(local.lambda_zip_path)}" 
  source = local.lambda_zip_path
  etag   = filemd5(local.lambda_zip_path)
}