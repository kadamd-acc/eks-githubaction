# Requirement is to run coredns pod on Fargate profile.
# Ref doc - https://docs.aws.amazon.com/eks/latest/userguide/fargate-getting-started.html
# Per AWS docs, you have to patch the coredns deployment to remove the
# constraint that it wants to run on ec2, then restart it.
# ONLY applicable for Windows OS. Kubectl must be installed in Windows and PATH variable should be set
# Running PowerShell command in Windows OS

# Updating Kubeconfig file with EKS cluster details
resource "null_resource" "update_kubeconfig_windows" {
  count = (var.user_os == "ubuntu" && var.k8s_cluster_type == "eks") ? 1 : 0
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-Command"]
    command     = <<EOF
    aws eks update-kubeconfig --region '${data.aws_region.current.name}' --name '${data.aws_eks_cluster.selected[0].name}'
EOF
  }
}

# Patching CoreDNS to remove EC2 annotations
resource "null_resource" "coredns_patch_windows" {
  count = (var.user_os == "ubuntu" && var.k8s_cluster_type == "eks") ? 1 : 0
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-Command"]
    command     = <<EOF
kubectl  patch deployment coredns --namespace '${var.k8s_namespace}' --type=json -p='[{"op": "remove", "path": "/spec/template/metadata/annotations", "value": "eks.amazonaws.com/compute-type"}]'
EOF
  }
  depends_on = [null_resource.update_kubeconfig_windows]
}

# Restarting CoreDNS Pod
resource "null_resource" "coredns_restart" {
  count = (var.user_os == "ubuntu" && var.k8s_cluster_type == "eks") ? 1 : 0
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-Command"]
    command     = <<EOF
kubectl  rollout restart -n '${var.k8s_namespace}'  deployment coredns
EOF
  }
  depends_on = [
    null_resource.coredns_patch_windows
  ]
}
