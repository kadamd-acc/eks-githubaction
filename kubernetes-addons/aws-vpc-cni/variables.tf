variable "kubernetes_namespace" {
  default = {}
}
variable kubernetes_service_account {
  default = {}
}

variable "enable_ipv6" {
  description = "Enable IPV6 CNI policy"
  type        = any
  default     = false
}

variable "addon_context" {
  type = object({
    aws_caller_identity_account_id = string
    aws_caller_identity_arn        = string
    aws_eks_cluster_endpoint       = string
    aws_partition_id               = string
    aws_region_name                = string
    eks_cluster_id                 = string
    eks_oidc_issuer_url            = string
    eks_oidc_provider_arn          = string
    tags                           = map(string)
    irsa_iam_role_path             = string
    irsa_iam_permissions_boundary  = string
  })
  description = "Input configuration for the addon"
}

variable "irsa_iam_policies" {

  type        = list(string)
  description = "IAM Policies for IRSA IAM role"
  default     = []
}

variable "aws_resource_name_prefix" {
  description = "A string to prefix any AWS resources created. This does not apply to K8s resources"
  type        = string
  default     = "k8s-"
}

variable "eks_cluster_id" {
  description = "EKS Cluster Id"
  type        = string
}