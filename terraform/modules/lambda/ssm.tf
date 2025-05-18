data "aws_ssm_parameter" "db_host" {
  name            = "/fast-food/auth/${var.lambda_env.STAGE}/db_host"
  with_decryption = false
}

data "aws_ssm_parameter" "db_port" {
  name            = "/fast-food/auth/${var.lambda_env.STAGE}/db_port"
  with_decryption = false
}

data "aws_ssm_parameter" "db_user" {
  name            = "/fast-food/auth/${var.lambda_env.STAGE}/db_user"
  with_decryption = false
}

data "aws_ssm_parameter" "db_name" {
  name            = "/fast-food/auth/${var.lambda_env.STAGE}/db_name"
  with_decryption = false
}

data "aws_ssm_parameter" "db_password" {
  name            = "/fast-food/auth/${var.lambda_env.STAGE}/db_password"
  with_decryption = true
}

data "aws_ssm_parameter" "db_max_open_conns" {
  name            = "/fast-food/auth/${var.lambda_env.STAGE}/db_max_open_conns"
  with_decryption = false
}

data "aws_ssm_parameter" "db_max_idle_conns" {
  name            = "/fast-food/auth/${var.lambda_env.STAGE}/db_max_idle_conns"
  with_decryption = false
}

data "aws_ssm_parameter" "db_conn_max_lifetime" {
  name            = "/fast-food/auth/${var.lambda_env.STAGE}/db_conn_max_lifetime"
  with_decryption = false   
}

data "aws_ssm_parameter" "jwt_secret" {
  name            = "/fast-food/auth/${var.lambda_env.STAGE}/jwt_secret"
  with_decryption = true
}

data "aws_ssm_parameter" "jwt_expiration" {
  name            = "/fast-food/auth/${var.lambda_env.STAGE}/jwt_expiration"
  with_decryption = false
}




