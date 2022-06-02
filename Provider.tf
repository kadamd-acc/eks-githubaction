

provider "aws" {
  region     = var.region_name
  access_key = "ASIA2ZCHYB755DWJM4RW"
  secret_key = "91HXMlpUTTO1jyl2VznQdJJrQaqa0LXtUzMuGCtp"
  token      = "IQoJb3JpZ2luX2VjEGYaCXVzLWVhc3QtMSJHMEUCIDuhJ/PKS2MTn582EUcXeo0/g3AhCKiK2QpFmTyvAcQsAiEA3sL1+FmdWxSAQwrfyLoaJ7sREJm7ZfwiylmBDz4N29wqrwIIXxACGgw3NDEwMzIzMzMzMDciDDr3uO75RPzACTeGCSqMAvREUASF3TnR9rLju+Kc9m9Y+dJVVIs5+x7gKj0XxaJxJRtTLWrALZ/imnMAd4W5aCvh0A309Nq/rMLJ4pOCCDteCQCb8gfkLN5l6OQEI6izTJmChHVAXxHzaeZuaEfFdJk8OzGe38glQTNPT0zD1tuaVawKpoO6eqyZ3yYNZyp1pYoipf7O3zKPf0qG2FwXDBfNNsjPN+Z80TdVNcpi/ijUMS0bu2Eyewq2+lcE6mz368CukQ96YOKIYehd5cxXCFquGHnKibZwlvRqMu2OpCvF1viZA1qHhhqcSR/8RX78C4Iqf30y/2XdhVv32UIE/evqJJGblVLSvVP8RWTR1/27D+sFTysRuAT4wRYw9fPilAY6nQFF7bwO5egPcjl1q2vdDC78GvBQfoyQUH7NLX2V1vzohDW67J9ASyfzExx+cmIboB9dULI8bjhhp+PWePFB1OROrxiFAG1OgpZaXUY2157B+s29dPeYQyTEBJNgu1zCUglujdeJwThubfaLG88icaMPK1xbjyA3vZ8gw8GmSHJuBUL4yiCS4tfqCkCTMu3g3j9Pb7kkj7mRnKp14XeH"
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