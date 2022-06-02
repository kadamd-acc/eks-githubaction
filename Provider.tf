

provider "aws" {
  region     = var.region_name
  access_key = "ASIA2ZCHYB75YT2MMBFX"
  secret_key = "8/+Q+dRY67AYQAz/Reb1jm8mbrgkVG9OGAdNZ4Sj"
  token      = "IQoJb3JpZ2luX2VjEGQaCXVzLWVhc3QtMSJIMEYCIQCy8ogAW45gzQm/vIMn8AUu/SsAeqS595cs9NrRoIV08gIhALLwV+mJKGLICEdlAg0uXg/lK2pJLR+idJvTVp3KOsEDKq8CCF0QAhoMNzQxMDMyMzMzMzA3Igx12QaitCMZph4qHroqjAJLVvYg9OIdTbC19btwB+Xgow0BwfHZRkLPvs6um4Aj8JRLFsWJxKGJAgMKrouK9zMYPxY6IN6OxeQjsjaH5bHquoU/MKXbI4CbP/eHxKLKTSkZXJpqJt9aUw7Gem9/gMFdnb8I7uG6DtCFxWw1f1bFNT5z28ja9bAOIsJt59zbDre9clqO9e+Ar+5UOvZ/stLl4ZvfsKgkFaBrYgCRgWubnQ+A+LNp0iO6AVKvHvQ1sHmCjco4OffODznzdVDn2+UkB/a2qyRrOXYqfCOjV4D+NM37b2yhrERPbrm+USE8UOezw7oWMgQKTW3mV9Rvkx+9tPR7IiK27uK7jKTr1DCIFydti6rQuSdvgDdNMP6/4pQGOpwB2O4CZ2n9BaU5i632YjnVxBIX6NbvzckKNzoUWkE0Nxj3Yl+xSb0xFo1DS/gKMmfQpy2aDq1aGRxv1DHMgAOkpgqIvlHRfGSuffG65MYFlnQSdSFUgbxBdYraRAiRhue+jK1hSK4Pf9f1SN9v+B14IxDXrD5gdvOox48MnCAbUfV2mH6x1pvGBsgL/6qktOJVdwFBfqv5Rwfyrbg6"
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