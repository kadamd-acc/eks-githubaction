locals {
  alb_controller_helm_repo     = "https://aws.github.io/eks-charts"
  alb_controller_chart_name    = "aws-load-balancer-controller"
  alb_controller_chart_version = var.aws_load_balancer_controller_chart_version
  aws_alb_ingress_class        = "alb"
  aws_vpc_id                   = data.aws_vpc.selected.id
  aws_region_name              = data.aws_region.current.name
  aws_iam_path_prefix          = var.aws_iam_path_prefix == "" ? null : var.aws_iam_path_prefix
}

resource "aws_iam_role" "this" {
  name        = substr("${var.aws_resource_name_prefix}${var.k8s_cluster_name}-aws-load-balancer-controller", 0, 64)
  description = "Permissions required by the Kubernetes AWS Load Balancer controller to do its job."
  path        = local.aws_iam_path_prefix

  tags = var.aws_tags

  force_detach_policies = true

  assume_role_policy = var.k8s_cluster_type == "vanilla" ? data.aws_iam_policy_document.ec2_assume_role[0].json : data.aws_iam_policy_document.eks_oidc_assume_role[0].json
}


resource "aws_iam_policy" "this" {
  name        = substr("${var.aws_resource_name_prefix}${var.k8s_cluster_name}-alb-management",0,64)
  description = format("Permissions that are required to manage AWS Application Load Balancers.")
  path        = "/" #local.aws_iam_path_prefix
  # We use a heredoc for the policy JSON so that we can more easily diff and
  # copy/paste from upstream. Ignore whitespace when you diff to more easily see the changes!
  # Source: `curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.3.1/docs/install/iam_policy.json`
  policy = file("${path.module}/iam_policy.json")
        tags = {
                 Name        = "${var.k8s_cluster_name}-lb_controller-iam"
                }
  }

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = aws_iam_policy.this.arn
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "vpc-cni-addon" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       =  aws_iam_role.this.name
}

resource "kubernetes_service_account" "this" {
  automount_service_account_token = true
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = var.k8s_namespace
    annotations = {
      # This annotation is only used when running on EKS which can
      # use IAM roles for service accounts.
      "eks.amazonaws.com/role-arn" = aws_iam_role.this.arn
    }
    labels = {
      "app.kubernetes.io/name"       = "aws-load-balancer-controller"
      "app.kubernetes.io/component"  = "controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
  depends_on = [var.alb_controller_depends_on]
}

resource "kubernetes_cluster_role" "this" {
  metadata {
    name = "aws-load-balancer-controller"

    labels = {
      "app.kubernetes.io/name"       = "aws-load-balancer-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  rule {
    api_groups = [
      "",
      "extensions",
    ]

    resources = [
      "configmaps",
      "endpoints",
      "events",
      "ingresses",
      "ingresses/status",
      "services",
    ]

    verbs = [
      "create",
      "get",
      "list",
      "update",
      "watch",
      "patch",
    ]
  }

  rule {
    api_groups = [
      "",
      "extensions",
    ]

    resources = [
      "nodes",
      "pods",
      "secrets",
      "services",
      "namespaces",
    ]

    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
  depends_on = [var.alb_controller_depends_on]
}

resource "kubernetes_cluster_role_binding" "this" {
  metadata {
    name = "aws-load-balancer-controller"

    labels = {
      "app.kubernetes.io/name"       = "aws-load-balancer-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.this.metadata[0].name
  }

  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.this.metadata[0].name
    namespace = kubernetes_service_account.this.metadata[0].namespace
  }
}

resource "helm_release" "alb_controller" {

  name       = "aws-load-balancer-controller"
  repository = local.alb_controller_helm_repo
  chart      = local.alb_controller_chart_name
  version    = local.alb_controller_chart_version
  namespace  = var.k8s_namespace
  atomic     = true
  timeout    = 900

  dynamic "set" {

    for_each = {
      "clusterName"           = var.k8s_cluster_name
      "serviceAccount.create" = (var.k8s_cluster_type != "eks")
      "serviceAccount.name"   = (var.k8s_cluster_type == "eks") ? kubernetes_service_account.this.metadata[0].name : null
      "region"                = local.aws_region_name
      "vpcId"                 = local.aws_vpc_id
      "hostNetwork"           = var.enable_host_networking
    }
    content {
      name  = set.key
      value = set.value
    }
  }

  dynamic "set" {
    for_each = var.chart_env_overrides
    content {
      name  = set.key
      value = set.value
    }
  }

  depends_on = [var.alb_controller_depends_on]
}



#May not require the below code block

/*
# Generate a kubeconfig file for the EKS cluster to use in provisioners
data "template_file" "kubeconfig" {
  template = <<-EOF
    apiVersion: v1
    kind: Config
    current-context: terraform
    clusters:
    - name: ${data.aws_eks_cluster.selected[0].name}
      cluster:
        certificate-authority-data: ${data.aws_eks_cluster.selected[0].certificate_authority.0.data}
        server: ${data.aws_eks_cluster.selected[0].endpoint}
    contexts:
    - name: terraform
      context:
        cluster: ${data.aws_eks_cluster.selected[0].name}
        user: terraform
    users:
    - name: terraform
      user:
        token: ${data.aws_eks_cluster_auth.selected[0].token}
  EOF
}

# Since the kubernetes_provider cannot yet handle CRDs, we need to set any
# supplied TargetGroupBinding using a null_resource.
#
# The method used below for securely specifying the kubeconfig to provisioners
# without spilling secrets into the logs comes from:
# https://medium.com/citihub/a-more-secure-way-to-call-kubectl-from-terraform-1052adf37af8
#
# The method used below for referencing external resources in a destroy
# provisioner via triggers comes from
# https://github.com/hashicorp/terraform/issues/23679#issuecomment-886020367
resource "null_resource" "supply_target_group_arns" {
  count = (length(var.target_groups) > 0) ? length(var.target_groups) : 0

  triggers = {
    kubeconfig  = base64encode(data.template_file.kubeconfig.rendered)
    cmd_create  = <<-EOF
      cat <<YAML | kubectl -n ${var.k8s_namespace} --kubeconfig <(echo $KUBECONFIG | base64 --decode) apply -f -
      apiVersion: elbv2.k8s.aws/v1beta1
      kind: TargetGroupBinding
      metadata:
        name: ${lookup(var.target_groups[count.index], "name", "")}-tgb
      spec:
        serviceRef:
          name: ${lookup(var.target_groups[count.index], "name", "")}
          port: ${lookup(var.target_groups[count.index], "backend_port", "")}
        targetGroupARN: ${lookup(var.target_groups[count.index], "target_group_arn", "")}
        targetType:  ${lookup(var.target_groups[count.index], "target_type", "instance")}
      YAML
    EOF
    cmd_destroy = "kubectl -n ${var.k8s_namespace} --kubeconfig <(echo $KUBECONFIG | base64 --decode) delete TargetGroupBinding ${lookup(var.target_groups[count.index], "name", "")}-tgb"
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    environment = {
      KUBECONFIG = self.triggers.kubeconfig
    }
    command = self.triggers.cmd_create
  }
  provisioner "local-exec" {
    when        = destroy
    interpreter = ["/bin/bash", "-c"]
    environment = {
      KUBECONFIG = self.triggers.kubeconfig
    }
    command = self.triggers.cmd_destroy
  }
  depends_on = [helm_release.alb_controller]
}
*/