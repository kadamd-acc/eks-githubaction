## kubernetes aws-load-balancer-controller
/*
locals {
  namespace      = lookup(var.helm, "namespace", "kube-system")
  serviceaccount = lookup(var.helm, "serviceaccount", "aws-load-balancer-controller")
}
*/

module "irsa" {
  source         = "../iam-role-for-serviceaccount"
  name           = "${var.service_account_name}-${var.environment}-irsa"
  namespace      = var.namespace
  serviceaccount = var.service_account_name
  oidc_url       = var.cluster_identity_oidc_issuer_url
  oidc_arn       = var.cluster_identity_oidc_issuer_arn
  policy_arns    = [aws_iam_policy.lbc.arn]
  tags           = var.tags
}

resource "aws_iam_policy" "lbc" {
  name        = local.name
  tags        = merge(local.default-tags, var.tags)
  description = format("Allow aws-load-balancer-controller to manage AWS resources")
  path        = "/"
  policy      = file("${path.module}/policy.json")
}

/*
resource "helm_release" "lbc" {
  name            = lookup(var.helm, "name", "aws-load-balancer-controller")
  chart           = lookup(var.helm, "chart", "aws-load-balancer-controller")
  version         = lookup(var.helm, "version", null)
  repository      = lookup(var.helm, "repository", "https://aws.github.io/eks-charts")
  namespace       = var.namespace
  cleanup_on_fail = lookup(var.helm, "cleanup_on_fail", true)

  dynamic "set" {
    for_each = merge({
      "clusterName"                                               = var.cluster_name
      "serviceAccount.name"                                       = var.service_account_name
      "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = module.irsa.arn
    }, lookup(var.helm, "vars", {}))
    content {
      name  = set.key
      value = set.value
    }
  }
}
*/

resource "helm_release" "lb_controller" {
  depends_on = [module.irsa]
  #count      = var.enabled ? 1 : 0
  name       = var.helm_chart_name
  chart      = var.helm_chart_release_name
  repository = var.helm_chart_repo
  version    = var.helm_chart_version
  namespace  = var.namespace
  cleanup_on_fail = var.cleanup_on_fail

  set {
    name  = "clusterName"
    value = var.cluster_name
  }
/*
  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }
  */

  set {
    name  = "serviceAccount.name"
    value = var.service_account_name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.irsa.arn
  }


  values = [
    yamlencode(var.settings)
  ]
}