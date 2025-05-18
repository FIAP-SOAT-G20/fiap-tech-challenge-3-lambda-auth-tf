variable "lambda_env" {
  type = map(string)
  default = {
    STAGE     = "prod"
    ENVIRONMENT = "production"
  }
}
