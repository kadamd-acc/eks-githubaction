

provider "aws" {
  region     = var.region_name
  access_key = "ASIA2ZCHYB755H6A47EE"
  secret_key = "wYqdbAj8yPrYpPUkOFQuquPSlYe8wNgO6GiPzoZ2"
  token      = "IQoJb3JpZ2luX2VjEHUaCXVzLWVhc3QtMSJHMEUCIAQUh1GOfaYbbA68AfR6paN5x3nwKiFiJEMSDjXKghcQAiEA0NvpMcNHcli7YkvWngfmH24m2eLh/WC5vr4LZ8eSXRQqrwIIbhACGgw3NDEwMzIzMzMzMDciDOl3Z6VxBL4ozPsbLSqMAvAyATwynSiJgOWXvwEte8dQa9gzxyqSrF7X063wVcZKecmGZeUXbh1RFT+nwRzhTicVEb2nCTCzmWNZH8+hwROa5nmm+5FjgJF4H8NqXCRBGhKlAEaW0AmoXkpkNJKVQ7R7taENVTQkladDdnwMDkw1GDQVbnGzRkX3PGdIcrr3zbWrO/IyX+7IwR6iNOZTOx/TAiIUQBa6R2hCUHJ57Pp246uoFoP12CPykHHn9RN/H7yFHb5zDDE7uy6CDeG3D9+IuYe7TkQf7ZS1c2SY+Fn1oXND1dwc7IG59CuCWSLqWKIb+isJs9GADKLjclf2TJA89a2B7WgoJU/zScWQQM/CjGhtspRipNH8xpsw8KDmlAY6nQH5Fp2H1461HcNaqlCgxzzmRAmSlRM6pVSFKRwPtr72+TXG96Crhfsl3Ms2V7dcjT0lqRdVtKqVcRrtrhgYNW9zZFZofNqIFRUdH6X197Zgaa7K4fbltnjgXVnP+Esn0/lbRrq/Y+OxVFaSiOhCpJR3/hjJ6/vjqY64QoQBVvshJ6Rx8Sc8xXmNW+3LM4KLcdm/JomOYU0Q3mgtduku"
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