data "aws_iam_role" "lambda_exec" {
  name = "LabRole"        # exact role name created by the admin
}