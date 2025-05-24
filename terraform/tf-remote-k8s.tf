data "terraform_remote_state" "k8s" {
  backend = "s3"
  config = {
    bucket = "fastfood-terraform-state-g22-tc3"
    key = "fiap/k8s/terraform.tfstate"
    region = "us-east-1"
  }
}