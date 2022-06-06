#provider "aws" {
#  region = "var.region_name"
#  profile = "AWS_741032333307_User"
#}

provider "aws" {
  region     = var.region_name
  access_key = "ASIA2ZCHYB75SD6KPTUS"
  secret_key = "2pH9jB5gf2OGuPPL7/EVikg1tyX1Hyb+sM3GeSCv"
  token      = "IQoJb3JpZ2luX2VjEL3//////////wEaCXVzLWVhc3QtMSJHMEUCIQCIGfvuwNKRHSTu7bdOBiE462jie+mgcPhNP/jgiyd6ugIge3O39sdkF2hDgZS4o8Bp1A/r53mfZ+K15vXz3x9U2I4quAIItv//////////ARACGgw3NDEwMzIzMzMzMDciDAlbhcIYrYABn7Y+xSqMAsIUUBKM7u2YXYXxeaEiPCYksXb1NInKLqN/7ztM9Ame8rntiG5LB7GCeu2Lc8EUbfgcxwq9I/hPki36iPPsPhk1aj+UsDhzZJynMWacppJtSHmr7208Awf8EouooLr2e5lgJOJFo2hdb+Vjtd2BdwT9zhFlHdHklfdnngv3imxATxtOTSDW1U9U6JwXUD3Yaq/yd3TBpVZfda+h9U6iQIZicgc+TZpyqLpIyoH4xFYItvt9FbFqlfyo3brg0Onl9jNWim2lJCD6IRh+WLz6PyqpTd+ealMv+TEbELYRjuPENb8/LwkVkuR2454epAWNG7GR/raWN03IFBzVx5VW9ZwFqbC3Bu44pKp+0o0w3Ij2lAY6nQF3lvOlqixFiSfvn4w3KjRtO1vifvCnzJ9wd0RLpUzKFv0T5XMSN19BCB9yAdB1dsFZCNiRLQBfhB4pAyhT0BnP2qik+QXFHL6Mz15xNk7bYQmHiKDe1PKX0wQjub8xrEsbe9HwiIsmHZVEwlZcQWAz0ZOsTTb4xWrBAlYpPptEPWs4DEffCbzxpa/lmq9o4nd4Wr4qjo2PAuUd0qDv"
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