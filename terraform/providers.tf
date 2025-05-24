provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project = "fastfood-auth-g22-tc3"
      Environment = var.lambda_env.ENVIRONMENT
    }
  }
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.k8s.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.k8s.outputs.cluster_ca_certificate)
  token                  = data.terraform_remote_state.k8s.outputs.cluster_token
}