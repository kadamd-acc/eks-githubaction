#provider "aws" {
#  region = "var.region_name"
#  profile = "AWS_741032333307_User"
#}

provider "aws" {
  region     = var.region_name
}
terraform {
  backend "s3" {
    bucket = "landg-terraform-state"
    key    = "eks/test/terraform.tfstate"
    region = "eu-west-2"
    encrypt= true

  }
}
##
#resource "aws_s3_bucket" "terraform-state" {
#  bucket = "landg-terraform-state"
#  lifecycle {
#    prevent_destroy = true
#  }
#  versioning {
#    enabled = true
#  }
#  server_side_encryption_configuration {
#    rule {
#      apply_server_side_encryption_by_default {
#        sse_algorithm = "AES256"
#      }
#    }
#  }
#
#}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  token                  = data.aws_eks_cluster_auth.aws_iam_authenticator.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  config_context =  data.aws_eks_cluster.eks_cluster.arn
  config_path = "/home/runner/.kube/config"
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks_cluster.endpoint
    token                  = data.aws_eks_cluster_auth.aws_iam_authenticator.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    config_context =  data.aws_eks_cluster.eks_cluster.arn 
    config_path = "/home/runner/.kube/config"

  }
}
#
#provider "kubernetes" {
#  host                   = data.aws_eks_cluster.eks_cluster.endpoint
#  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
#
#  exec {
#    api_version = "client.authentication.k8s.io/v1alpha1"
#    command     = "aws"
#    # This requires the awscli to be installed locally where Terraform is executed
#    args = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks_cluster.id]
#  }
#}
#
#provider "helm" {
#  kubernetes {
#    host                   = data.aws_eks_cluster.eks_cluster.endpoint
#    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
#
#    exec {
#      api_version = "client.authentication.k8s.io/v1alpha1"
#      command     = "aws"
#      # This requires the awscli to be installed locally where Terraform is executed
#      args = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks_cluster.id]
#    }
#  }
#}