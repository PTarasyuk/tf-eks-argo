terraform {
  backend "s3" {
    assume_role = {
      role_arn = "arn:aws:iam::${var.account_id}:role/tf-admin"
    }
    bucket = "tf-eks-argo-state-backend"
    key = "test/terraform.tfstate"
    region = "eu-west-3"
    dynamodb_table = "tf-eks-argo-state-lock"
    encrypt = true
  }
}