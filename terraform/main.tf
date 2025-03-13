data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  env_name = "${var.project_name}-${var.environment}-${replace(var.eks.cluster_version, ".", "-")}"
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Terraform   = "true"
  }
}
