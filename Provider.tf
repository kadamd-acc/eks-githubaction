#terraform {
#  backend "s3" {
#    bucket = "landg-terraform-state"
#    key    = "eks/test/terraform.tfstate"
#    region = "eu-west-2"
#    encrypt= true
#
#  }
#}
provider "aws" {
  region = var.region_name
  profile = var.user_profile
  #shared_credentials_files = "/c/Users/deepak.haridas.kadam/.aws/credentials"
}


provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  token                  = data.aws_eks_cluster_auth.aws_iam_authenticator.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks_cluster.endpoint
    token                  = data.aws_eks_cluster_auth.aws_iam_authenticator.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    config_path = "~/.kube/config"

  }
}

