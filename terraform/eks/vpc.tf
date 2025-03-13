module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19"

  name = "${local.env_name}-vpc"
  cidr = var.vpc.cidr

  azs             = local.azs

  putin_khuylo = true

  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc.cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc.cidr, 8, k + 48)]
  intra_subnets   = [for k, v in local.azs : cidrsubnet(var.vpc.cidr, 8, k + 52)]

  enable_flow_log = var.vpc.enable_flow_log

  enable_nat_gateway  = var.vpc.enable_nat_gateway
  single_nat_gateway  = var.vpc.single_nat_gateway

  tags = merge(
    local.tags,
    {
      "kubernetes.io/role/elb" = "1"
      "kubernetes.io/role/internal-elb" = "1"
    }
  )
}

# module "endpoints" {
#   source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
#   version = "5.19"

#   vpc_id = module.vpc.vpc_id

#   create_security_group = true
#   security_group_description = "VPC endpoint security group"
#   security_group_rules = {
#     ingress_https = {
#       description = "HTTPS from VPC"
#       cidr_blocks = [module.vpc.vpc_cidr_block]
#     }
#   }
  
#   endpoints = {
#     sts = {
#       service             = "sts"
#       private_dns_enabled = true
#       subnet_ids          = module.vpc.private_subnets
#       tags = { Name = "${local.env_name}-vpc-sts-ep" }
#     }
#   }
# }
