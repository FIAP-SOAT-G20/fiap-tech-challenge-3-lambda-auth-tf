data "aws_iam_role" "lambda_exec" {
  name = "RoleForLambdaModLabRole"        # exact role name created by the admin
}