# Policy

resource "aws_iam_policy" "lb_controller_policy" {
  depends_on  = [var.mod_dependency]
  count       = var.enabled ? 1 : 0
  name        = "${var.cluster_name}-aws-alb-controller"
  description = format("Allow aws-load-balancer-controller to manage AWS resources")
  path        = "/"
  policy      = file("${path.module}/iam_policy.json")
    tags = {
    Name        = "${var.cluster_name}-lb_controller-iam"
  }
}

/*
resource "aws_iam_policy" "lb_controller" {
  depends_on  = [var.mod_dependency]
  count       = var.enabled ? 1 : 0
  name        = "${var.cluster_name}-alb-ingress"
  path        = "/"
  description = "Policy for alb-ingress service"

  policy = data.aws_iam_policy_document.lb_controller[0].json
}
*/

# Role
data "aws_iam_policy_document" "lb_controller_assume" {
  count = var.enabled ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.cluster_identity_oidc_issuer_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_identity_oidc_issuer, "https://", "")}:sub"

      values = [
        "system:serviceaccount:${var.namespace}:${var.service_account_name}",
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "lb_controller_role" {
  count              = var.enabled ? 1 : 0
  name               = "${var.cluster_name}-aws-alb-controller-role"
  assume_role_policy = data.aws_iam_policy_document.lb_controller_assume[0].json
}

resource "aws_iam_role_policy_attachment" "lb_controller" {
  count      = var.enabled ? 1 : 0
  role       = aws_iam_role.lb_controller_role[0].name
  policy_arn = aws_iam_policy.lb_controller_policy[0].arn
}