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
