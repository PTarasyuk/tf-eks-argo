module "eks" {
  source = "./eks"
  account_id = var.account_id
  project_name = var.project_name
  environment = var.environment
}

module "argo_cd" {
  depends_on = [module.eks]
  source = "./argocd"
}