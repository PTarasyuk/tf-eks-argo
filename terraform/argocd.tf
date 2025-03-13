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

resource "kubernetes_manifest" "argocd_root_app" {
  depends_on = [module.eks]
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind = "Application"
    metadata = {
      name = "podinfo-root"
      namespace = "argocd"
    }
    spec = {
      destination = {
        name = "in-cluster"
        namespace = "argocd"
      }
      source = {
        path = "argocd"
        repoURL = "https://github.com/PTarasyuk/tf-eks-argo"
        targetRevision = "HEAD"
      }
      project = "default"
      syncPolicy = {
        automated = {
          prune = true
          selfHeal = true
        }
      }
    }
  }
}

data "kubernetes_service" "argocd_server" {
  depends_on = [module.eks]
  metadata {
    name      = "argocd-server"
    namespace = helm_release.argocd.namespace
  }
}
