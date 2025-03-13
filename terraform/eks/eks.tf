module "eks" {
  putin_khuylo    = "true"
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 20.31"

  cluster_name    = "${local.env_name}-cluster"
  cluster_version = var.eks.cluster_version

  cluster_endpoint_public_access = var.eks.cluster_endpoint_public_access
  cluster_enabled_log_types      = var.eks.cluster_enabled_log_types

  cluster_addons = {
    coredns    = { most_recent = true }
    kube-proxy = { most_recent = true }
    vpc-cni    = { most_recent = true }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  
  control_plane_subnet_ids = module.vpc.intra_subnets

  eks_managed_node_groups = var.eks_managed_node_groups

  access_entries = {
    example = {
      principal_arn = "arn:aws:iam::${var.account_id}:role/tf-admin"
      policy_associations = {
        single = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  tags = local.tags
}