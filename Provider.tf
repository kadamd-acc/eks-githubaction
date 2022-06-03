#provider "aws" {
#  region = "var.region_name"
#  profile = "AWS_741032333307_User"
#}

provider "aws" {
  region     = var.region_name
  access_key = "ASIA2ZCHYB7532F7IPO5"
  secret_key = "35x2GIzb95xacoZvx8zL5kImSnTLd12qziMi527W"
  token      = "IQoJb3JpZ2luX2VjEHsaCXVzLWVhc3QtMSJHMEUCIDLqoBPD7BQqHi4+2Nm4NdRheergE5ZjtKCozIeZlCv7AiEAsvQadFlr+QP2Fn7i8pjGgxEoOXqqY0de3lzh1dqeSJMqrwIIdBACGgw3NDEwMzIzMzMzMDciDHs5CSdcSP4edHKWGSqMAlpfCZHpXExKUSWggBd8rHcHbFii2crqHO9jgiH00t3n8TIbb6rGUfz78cxD1yszguxsGihGJHUkkTcHgt5okxug3kwCbPcmmX2X568+Yj1UF3zbmBFmgzDO8/iuqQhgShk1zBE6AVkP2Sa2SgQTjipp57S1T9+k5aLwLIjhlaW6mfoqOwlgezu7YPEFnrgCzaNY7JJS5cwj1A+4kGBH3SBbVeGMvZO5y6xqVi24vhpoXCAtKh8DicPkZWJovj9wvvfYTPP3waBVGmqi3ilOtIcgPvYa+vVgZfEYE39+pQG0lx9zHY7A/ay37+aPvRrKzT1o1vcKIG9ixdih+uvHkOCQBWeJn1lnonj7UWww1MHnlAY6nQHAjGT9u+NxXZXRmW07h678FpMbg6u/BDByNS6NEKy8AXnWECntcsPpld0uRIUqmPGtonSpS54eBCr8pgwBIM3jJGazC+nSUoDtkM7EpCM/KtfUOfoqK7wD6kk/VXB5s/YtjT6SZEZwgnLSu0QciGBkHoA1fkryj7wJeUHS4AjNVXZ8/yrp3+wrBCCuIm0bSkCcBdJqaaSfmnPIMCcm"
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