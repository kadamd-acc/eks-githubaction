data "aws_iam_role" "service-account-role"{
  name = substr("${var.aws_resource_name_prefix}${var.eks_cluster_id}-aws-load-balancer-controller", 0, 64)
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name             = var.addon_context.eks_cluster_id
  addon_name               = "vpc-cni"
  addon_version            = "v1.11.0-eksbuild.1"
  resolve_conflicts        = "OVERWRITE"
  service_account_role_arn = data.aws_iam_role.service-account-role.arn
  # preserve                 = true

}


