provider "aws" {
  region = local.region
  assume_role {
    role_arn = "arn:aws:iam::${var.app_account_id}:role/${var.deploy_role}"
  }
}
