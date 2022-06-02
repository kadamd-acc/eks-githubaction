

provider "aws" {
  region     = var.region_name
  access_key = "ASIA2ZCHYB753DHA3PH6"
  secret_key = "lHC0Z7+J0ocoPxCY9cGPsvvDQCBBhCEyF6KsNAhe"
  token      = "IQoJb3JpZ2luX2VjEGUaCXVzLWVhc3QtMSJHMEUCIQDvFYpjvx7sbCoN05uguIgtN3Trqky2PkRAB3//HeM0vQIgcYNhGZ6PbeGsJaVdkRQ5q9gfRQrUk1bd+8aEuXgJWl4qrwIIXRACGgw3NDEwMzIzMzMzMDciDHtz0LnAPtRPpPtcBSqMAjYnvqe0COgG1fyIhs2jqebIOYYU/GoGgsRInZJRS3SBmx0hZHtKS5l/7SUttvXp1gyRNrjholdrvlniuk0igizvuLCvvsX7BaXcSJZ5lr+lALSMVf625emCTnzk2s7bljqoJsAR+ksqCKfOI3bEO5N9dCwOtpH+B8HWs9TzgavA8KS5KSCHhkRwSwAqqveqimIqIdnDjPOtIp6WfbanhzFsXqzZAgvsT6mDJEegK2s+7EKm13HHZ5lilMo1Ulr/E0WpEuNkTbE24oIXAIsM7b7oVIRBnq5UNlBiDHQ06+spM/TaoZeWonD89LnlMwdtrxtJMsN8yur08IXkD8wpob1B8f4dslFn1FfhGmgwpdHilAY6nQGOzh/mvp1mgiu2kyz6pp609DmO67hWq7xZ1KSOLPX61qyYY2v+vuXNkdr4MxVaTdbmsjuvSRZuFB9pSBVOcIL8xDHWYpicYcwMNv8Cb+iu4TYpjTUXrS1niqjAtdoF5i5tT5R2Sf0ws5VeW8Zo4voY41OJodL/KeZu5y4pHYwMQE6RCuZYoj1kG3x4zPSKkjKfFSDeNHK/pmq0noNn"
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