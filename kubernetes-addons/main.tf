#-----------------AWS Managed EKS Add-ons----------------------

module "aws_vpc_cni" {
  count         = var.enable_amazon_eks_vpc_cni ? 1 : 0
  source        = "./aws-vpc-cni"
  #addon_config  = var.amazon_eks_vpc_cni_config
  addon_context = local.addon_context
  kubernetes_namespace = "kube-system"
  kubernetes_service_account  = "aws-node"
  irsa_iam_policies = ["arn:${local.addon_context.aws_partition_id}:iam::aws:policy/AmazonEKS_CNI_Policy"]
  eks_cluster_id   = var.eks_cluster_id
}

module "aws_coredns" {
  count         = var.enable_amazon_eks_coredns ? 1 : 0
  source        = "./aws-coredns"
  addon_config  = var.amazon_eks_coredns_config
  addon_context = local.addon_context
}

module "aws_kube_proxy" {
  count         = var.enable_amazon_eks_kube_proxy ? 1 : 0
  source        = "./aws-kube-proxy"
  addon_config  = var.amazon_eks_kube_proxy_config
  addon_context = local.addon_context
}


