#provider "aws" {
#  region = "var.region_name"
#  profile = "AWS_741032333307_User"
#}

provider "aws" {
  region     = var.region_name
  access_key = "ASIA2ZCHYB7545PS5JFS"
  secret_key = "akUNT1fMZdJS+uGlB2UpGYOfG/UiBx+Sgokxl9kV"
  token      = "IQoJb3JpZ2luX2VjEN7//////////wEaCXVzLWVhc3QtMSJHMEUCIAp5Cx5BpSZsCFCSewW8kvkhnqs/inUE7d9C0RsSqRRzAiEAsaJQQitUzesrMv+U1U6bL+sFrZ58FknCMPCFvfiret0quAII1///////////ARACGgw3NDEwMzIzMzMzMDciDPOa8twKck+m30AYxCqMApIs2CzMxABtvJZHYQ7AXxVoTEcfJC6AJw09MlLsiBh6FU1qv5mfkhwHeGo6ozDyJhAIC4q8+Jm884dLb73wn78/wFVHEEtmOsSw1FZYzEbKM3ant4UeEJ5isOur4P+Lz0IrXXmRp+PyEB0gNH7y7GHE4u011WiqYAIayGUEWQXzzksbzNecNLmhwrhkNASYhojLpuLgO2g+IaQjp6vRJNh1QIjORY4Qy9d9lBqdjO2SzOy3/X+rkAXgLIRrUqBkHjEAB41jjTLu4apK52WkwMWKDAwFsWosIgSpy3Xq0QLseUyVH4/3K2Jqes/pQP0JInnX9BlCs/YE9YWjeHXBFpofXTLwIBBMuwHiiA8wxK/9lAY6nQGMKjJxrq81uBefPRVOQas/EBAYYIlfgeBfE+u33tIqLL5/NWYDyFWPT0KpnLJFmefi0BOTTPO5bAnn09OFcF1LbJmxew3uVhMhC1meppJtXsZyWqOE6mCglH9S0wRb0JvVcAZ6RzVAbmFk+TkHodpvYEbGzSdl39qXwBi0nlgmDN8urV/VZYui5oVLdShvdbCjuxkkIjGM2ZV8ovr2"

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