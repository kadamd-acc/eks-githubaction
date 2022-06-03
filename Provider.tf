#provider "aws" {
#  region = "var.region_name"
#  profile = "AWS_741032333307_User"
#}

provider "aws" {
  region     = var.region_name
  access_key = "ASIA2ZCHYB75VO2U4XO7"
  secret_key = "JmMYgjejR6TC6efFjbnqkjEjXa05gCaR32e618of"
  token      = "IQoJb3JpZ2luX2VjEHoaCXVzLWVhc3QtMSJGMEQCIEOSbGmLVG+1q/QHsNbqtS/qLjSeTcAXdBegwnrZMhVuAiALeTnBmuVEkoAIc4j3wuZDFEm8oJszYaQbMvNQu6VCIiqvAghyEAIaDDc0MTAzMjMzMzMwNyIMOPmXIBXpUPwAKMBqKowC3XRcW3E7WR07tG6nLPtYVp/0xElAlnYneHXFCxTrft6VUjiXSxAPwwYIvnKOf70DzZB2ZD8bVl1sVFjwdiK1Psv5dylkHKWiYgnkpCJ08xeKIWxQNWl0Md3mXuOBZOcltFzAdCwc4FThgpWXrBWJNMDOWJ3jAGDGsJ9nfhiApvmP+mRUYaXGUVggLZv8DHbrItBePvfj6HGbLEWFAPd7WZNWZg/OKbhsoHaAiQ8v3CrQLdHHcAJFoMFsbnzLjM7QwhEK2BZaEZDNEi8cHNrn03sk5yDYP6UDUe56EssSY7wIt2MG33H1OorRpjXJcRlkSrquySqkymfXodmZF2HEmQXUzGB6z4E73lcBtDDJnueUBjqeAQ8GpO0nZpYLL41MEfBtEIwTEeJqnhDID62KkWFvpEWbV5ADHwcxVXlJ1/PBMoi3nObC++iqtQ0rb/UwMOTE7wJyKDduJJ+SH2qBrdih+NMZFoCkCmf8MSo5EhKnZ3acJutnwQsBjFIdFTdvcOzYsjzItv+EOoG33WH9kcfTnsWo4Cr0wwQ4WgM0VB4yrQtuAzNf5edCNoMpKWqrEgaq"
}
#
#terraform {
#  backend "s3" {
#    bucket = "landg-terraform-state"
#    key    = "eks/test/terraform.tfstate"
#    region = "eu-west-2"
#    encrypt= true
#
#  }
#}
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