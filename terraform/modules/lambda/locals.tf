locals {
  lambda_zip_path = "../dist/function.zip"
}

locals {
  merged_env = merge(
    var.lambda_env,           # from tfvars
    { DB_HOST = data.aws_ssm_parameter.db_host.value },
    { DB_PORT = data.aws_ssm_parameter.db_port.value },
    { DB_USER = data.aws_ssm_parameter.db_user.value },
    { DB_PASSWORD = data.aws_ssm_parameter.db_password.value },
    { DB_NAME = data.aws_ssm_parameter.db_name.value },
    { DB_MAX_OPEN_CONNS = data.aws_ssm_parameter.db_max_open_conns.value },
    { DB_MAX_IDLE_CONNS = data.aws_ssm_parameter.db_max_idle_conns.value },
    { DB_CONN_MAX_LIFETIME = data.aws_ssm_parameter.db_conn_max_lifetime.value },
    { JWT_SECRET = data.aws_ssm_parameter.jwt_secret.value },
  )
}