### helm
/*
variable "helm" {
  description = "The helm release configuration"
  type        = any
  default = {
    repository      = "https://aws.github.io/eks-charts"
    name            = "aws-load-balancer-controller"
    chart           = "aws-load-balancer-controller"
    namespace       = "kube-system"
    serviceaccount  = "aws-load-balancer-controller"
    cleanup_on_fail = true
    vars            = {}
  }
}
*/

### security/policy
/*variable "oidc" {
  description = "The Open ID Connect properties"
  type        = map(any)
}*/

### description
variable "cluster_name" {
  description = "The kubernetes cluster name"
  type        = string
}

variable "petname" {
  description = "An indicator whether to append a random identifier to the end of the name to avoid duplication"
  type        = bool
  default     = true
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}



variable "cluster_identity_oidc_issuer_url" {
  type        = string
  description = "The OIDC Identity issuer for the cluster."
}


variable "enabled" {
  type        = bool
  default     = true
  description = "Variable indicating whether deployment is enabled."
}

/*
variable "cluster_identity_oidc_issuer" {
  type        = string
  description = "The OIDC Identity issuer for the cluster."
}
*/

variable "cluster_identity_oidc_issuer_arn" {
  type        = string
  description = "The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account."
}

variable "helm_chart_name" {
  type        = string
  default     = "aws-load-balancer-controller"
  description = "AWS Load Balancer Controller Helm chart name."
}

variable "helm_chart_release_name" {
  type        = string
  default     = "aws-load-balancer-controller"
  description = "AWS Load Balancer Controller Helm chart release name."
}

variable "helm_chart_repo" {
  type        = string
  default     = "https://aws.github.io/eks-charts"
  description = "AWS Load Balancer Controller Helm repository name."
}

variable "helm_chart_version" {
  type        = string
  default     = "1.3.2"
  description = "AWS Load Balancer Controller Helm chart version."
}

variable "cleanup_on_fail" {
  type        = bool
  default     = "true"
  description = "Clean Helm install on failure"
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "Whether to create Kubernetes namespace with name defined by `namespace`."
}

variable "namespace" {
  type        = string
  default     = "kube-system"
  description = "AWS Load Balancer Controller Helm chart namespace which the service will be created."
}

variable "service_account_name" {
  type        = string
  default     = "aws-alb-ingress-controller"
  description = "The kubernetes service account name."
}

variable "arn_format" {
  type        = string
  default     = "aws"
  description = "ARNs identifier, usefull for GovCloud begin with `aws-us-gov-<region>`."
}

variable "mod_dependency" {
  type        = any
  default     = null
  description = "Dependence variable binds all AWS resources allocated by this module, dependent modules reference this variable."
}

variable "settings" {
  type        = any
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values, see https://github.com/aws/eks-charts/tree/master/stable/aws-load-balancer-controller#configuration."
}


variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
  type = string
}