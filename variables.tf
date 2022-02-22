variable "region" {
  type        = string
  description = "AWS region code."
}

variable "access_key" {
  type        = string
  description = "Access key for IAM user."
}

variable "secret_key" {
  type        = string
  description = "Secret access key for IAM user."
}

variable "eks_service_role_name" {
  type        = string
  description = "AWS EKS Service Role name."
}

variable "eks_managed_group_service_role_name" {
  type        = string
  description = "AWS EKS Managed Group Service Role name."
}
