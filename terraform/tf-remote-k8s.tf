data "terraform_remote_state" "k8s" {
  backend = "s3"
  config = {
    bucket = var.bucket_remote_state
    key = var.key_k8s_remote_state
    region = var.aws_region
  }
}