

provider "aws" {
  region     = var.region_name
  access_key = "ASIA2ZCHYB75XBEDD35W"
  secret_key = "4B8CVIjm7SdvXRPstN06TIfr7D2aKo0mF9W0ehT+"
  token      = "IQoJb3JpZ2luX2VjEHUaCXVzLWVhc3QtMSJHMEUCIQD9bePmeiJPb4BRkze6knZaJC2e/UD8YRk+ehsowsyS0gIgXSvowvXhskfG/jNyVWYCP/DDNu/Y2ViFQ+j5ztp8bpoqrwIIbRACGgw3NDEwMzIzMzMzMDciDLjGaxVGGtZJcEmtOCqMAsXhY4+udiFP90dx7kATHCD1cExCliCfd6k/cv3D2Qfu31gCfwMvy665c/d0FPzkXTqyeLFMt6K8fIlsKixj3eJ6D7IdRyYGjYtj6U31PSQZtSPodCu3TyGLPXPiO1duNyP2hydgta0NZ2JhGsLno6LQKNkHE9yCzsh0fTzk+0lW+IInsoBPf+mhDX9OxMM9zVGNr0ZWUYJ3da4GdWEu7zxW3/uwI4Yp/gEAv0sKBUU9cHHoL6UfB5pHFJ53EqWMeUuY2HrabcekPjxIkcMTe42zIeKzamDHfgVaHnYSwFkvADB/2ee5L83hdpKO8OOxpRSSeSKMqo9JlRFdCyuQnSzHa9pZH95ARGVGxNQw8ZLmlAY6nQH7fTEV3hVYSnA7hQ2TpPN12XeNV/4gsfxwPbgST0f8Z3K2GiJygEreE4c81WkBpMLMsbYp3Skr+4xpW2CkWuNI4kw3I1dpphZcSjgoiJ936qRB9AdyozdZy0fIwo5BIO2VyjOowHfSGfxiXw92PqlWRglcEePjfdDc/SfgKwaW7OaC9UmuYhE3OIwN6hYGvhZYCo4CknpYmF0xHvbj"
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