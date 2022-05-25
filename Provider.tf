provider "aws" {
  region  = "eu-west-2"
  profile = "AWS_741032333307_User"
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.eks_cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.eks_cluster_id
}

