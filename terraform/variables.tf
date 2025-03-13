variable "account_id" {
  description = "A AWS account ID"
  type = string
}

variable "region" {
  description = "A AWS region"
  type = string
}

variable "project_name" {
  description = "A project name to be used in resources"
  type = string
}

variable "environment" {
  description = "dev/test/prod, will be used in AWS resources Name tag, and resources names"
  type = string
}

variable "vpc" {
  type = object({
    cidr               = string
    enable_flow_log    = bool
    enable_nat_gateway = bool
    single_nat_gateway = bool
  })
  default = {
    cidr               = "10.1.0.0/16"
    enable_flow_log    = false
    enable_nat_gateway = true
    single_nat_gateway = true
  }
}

################################################################################
# EKS Module
################################################################################

variable "eks" {
  description = "EKS cluster itslef parameters"
  type = object({
    cluster_version                = string
    cluster_endpoint_public_access = bool
    cluster_enabled_log_types      = list(string)
  })
  default = {
    cluster_version                = "1.32"
    cluster_endpoint_public_access = true
    cluster_enabled_log_types      = [
      "api",
      "audit",
      "authenticator",
      "controllerManager",
      "scheduler"
    ]
  }
}

variable "eks_managed_node_groups" {
  description = "EKS Managed NodeGroups setting, one item in the map() per each dedicated NodeGroup"
  type = map(
    object({
      desired_capacity = number
      max_capacity     = number
      min_capacity     = number
      instance_types   = list(string)
    })
  )
  default = {
    default = {
      desired_capacity = 1
      max_capacity     = 1
      min_capacity     = 1
      instance_types   = ["t3.medium"]
    }
  }
}
