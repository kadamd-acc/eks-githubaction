#provider "aws" {
#  region = "var.region_name"
#  profile = "AWS_741032333307_User"
#}

provider "aws" {
  region     = var.region_name
  access_key = "ASIA2ZCHYB752I446UMS"
  secret_key = "tAEvqJ3fUP1vctJ9S3zwGviq2vUzVJurINLmAP6D"
  token      = "IQoJb3JpZ2luX2VjEH0aCXVzLWVhc3QtMSJHMEUCICAsoa1f/KB6g9glt/YGlDOd9FLKBluHli564ICTuhSWAiEArrvaOD4AvJ+glSta8w9YwBaiUSkL9FJtGhShcq9gYeoqrwIIdhACGgw3NDEwMzIzMzMzMDciDEZvyq1YojvIk30ksyqMAue6qSMflkwQLmQsxdfsrrAbab5za67h6GSwRLyKNLywXddxEMnhR4kOuudDngn21D1lPXr3zYgVX0TKL9wRGKZU5s/gJFb4N5/H0oLvuj4yLtusY4Y9XWuk+TaN8Q6HNSWoIIkzMY8f6I+yC5BHGXgZthFaLTMCTa4cSzJmOFLXjaQb9DHq0j/WV81Unzax2YktoKrlLZ0/mf1f/rLmN6gUSeOLycM5SPEjudXuoQkweCuFJ3v2fn6mvOlkV9GUj8ZNS8Dmhebd20Z1gdU1fXnQ8DYHeqQoaOd68HaoDZjQAlhDZnijGVS4xDjR5DQm//2YJ4JtnunEwKSEE8xpxkKy6pVesW1kccbWqVswnfrnlAY6nQGhFTq6JIywb77WSJvrRRbUdVhLIaEehod/Qzoj64JrTxKB8msUXHZdUqL61LagsdiSygjpQ2J8qVhgmK+wRw9bOyYXBatJy0VbDXjZDZgSXsNBaBJVR3tHDlbbznqld72E3z7511c+QspDOfBub3jOoCB3CM0JgQjlXhPvptkt8YzQRHYOAZTvMiqgBvc93FwcjzikvlPgPdSL5Hn9"
  #
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
  config_path = "./.kube/config"
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks_cluster.endpoint
    token                  = data.aws_eks_cluster_auth.aws_iam_authenticator.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    config_path = "./.kube/config"
    
  }
}