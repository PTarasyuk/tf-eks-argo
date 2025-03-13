resource "helm_release" "argocd" {
  depends_on = [module.eks]
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.8.0"
  namespace  = "argocd"
  create_namespace = true

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "server.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }

  set {
    name  = "configs.repositories[0].name"
    value = "tf-eks-argo"
  }

  set {
    name  = "configs.repositories[0].url"
    value = "https://github.com/PTarasyuk/tf-eks-argo"
  }

  set {
    name  = "configs.repositories[0].type"
    value = "git"
  }
  
}

data "kubernetes_service" "argocd_server" {
 metadata {
   name      = "argocd-server"
   namespace = helm_release.argocd.namespace
 }
}
