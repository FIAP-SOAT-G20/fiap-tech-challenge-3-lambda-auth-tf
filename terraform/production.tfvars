api_env = {
  STAGE     = "prod"
}

lambda_env = {
  STAGE     = "prod"
  ENVIRONMENT = "production"
}

bucket_remote_state = "fast-food-terraform-state-g22-tc3"
key_k8s_remote_state = "fiap/k8s/terraform.tfstate"
key_db_remote_state = "fiap/db/terraform.tfstate"
aws_region = "us-east-1"