

provider "aws" {
  region     = var.region_name
  access_key = "ASIA2ZCHYB756NYSLMUR"
  secret_key = "hsQJ/RR7UpybVMDO4FVSD+lCjAdVH7f3Fk0ZFfeS"
  token      = "IQoJb3JpZ2luX2VjEGUaCXVzLWVhc3QtMSJIMEYCIQDnmtuTyxP2njK7PFPtR+YV8WIgDeOKLtWDjbVvxzsUzgIhAKNx+RoL5I1oqqo5cLOM7HWFvLe3/ocvUPGufAy6cHkaKq8CCF4QAhoMNzQxMDMyMzMzMzA3IgzKz/bfR4MUkhthCKoqjAK6ZLSYJvv0P6Am6hFznlTweWweIhHRJIPadSTMiU20gUY+Y3NG75w/UCaAvrcj1zw03WDJ+L0mahBDvhnhvh9sMUKPkXq8o7ZtwRl1RYVjvRA4VWekH8wXMi2WEhGS1AbR4KG6cqONxA1i4aKBuK2fENptJwTAN5s6QffEhtUyEHta5rdJ2le/7L5qY+waLB40hpY5EizhyHMmzcZvyuJidSEqHqGaiPGguTPHgbo9RIeqq1sUvac1q6CFQJr1bO7Qukf7C0TzKq5KoWHVJ2wmZrLSoR1ccTSYKsBzKvns8f7cfxf/meNz1ltHAlQgN1yozvnTto/q9sFlurOsU2X2wnc9sNwzwxPn3jLOMKnp4pQGOpwBZ+5AyWASGr45SqKk7tCzZX7zOAB/FaHOZ1N1jKBEhNtrEmdKBta8J05Y5Kx9/rOBVXS8tAGdh43el2s4cablUElSJANBzJsHrhce73JeudEDz9/bStPkd4lyYr6g/Zqk9jwc546LQOzyNfSDOEd61JIBvbDeUcfIUyOvq04XbNdueBCmAwhbzkNEiSC3JswdEVwNIwIxfqBc7CON"
}

terraform {
  backend "s3" {
    bucket = "landg-terraform-state"
    key    = "eks/test/terraform.tfstate"
    region = "eu-west-2"
    encrypt= true

  }
}
#
resource "aws_s3_bucket" "terraform-state" {
  bucket = "landg-terraform-state"
  lifecycle {
    prevent_destroy = true
  }
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

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