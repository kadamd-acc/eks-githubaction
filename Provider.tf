#provider "aws" {
#  region = "var.region_name"
#  profile = "AWS_741032333307_User"
#}

provider "aws" {
  region     = var.region_name
  access_key = "ASIA2ZCHYB756FT3N7EG"
  secret_key = "uv5VuoOVlThIsRNct9pK84XDizxasFm3urtL16c7"
  token      = "IQoJb3JpZ2luX2VjEL7//////////wEaCXVzLWVhc3QtMSJHMEUCIDWP+H0NszrbJ9onciDiTFQ7/MPxU8ZvWPbZfSusoFrXAiEA/K2mczz+m6QGVpp2g7dhFAXlne6cit0oUQoWjt0p1KoquAIItv//////////ARACGgw3NDEwMzIzMzMzMDciDOdCsonx18IafvFaXSqMAtJfuHG+eKS8wUSksq9J5pyIBpValROSQ7+Va3pf6acuvDUe4a/wf4Y7w5nqfuL3mW84NMFaJbwCZ47FuwJ4FbuGEjOWeTbZnyKrvBm6Zsk0hgKjj8gdaeGokXDD4ES2XMDUpwIr57TtmOQAJ5l84WF5PixkDP19qQOGBHFQf9QJ0azBNEF4IliYWH/YJpq1fdI4exlHLdiGC2wvZ+oEpge2iAGDhB/SaVzVjh2UB7Yj2aBaXfyQubw5kPzAAr8iHpARvHufzieek1ZWV+i3zRUT9GAAMfcSOu77TA01WEVjCVBVTqaknUcjJgv4e8T8Lxu6Mh68Gm86cw3S6qu9uULeH/EmbuO5qqqrm5IwxJz2lAY6nQHKZltBO1+dfA0R5gqLrh7V+HV8LMd0fv1ZOy0hkACuxQZbY9X0ZBrgnCRRnRBGgzOmMMZ2ALN2eZqY84c8XvlXfUHME57tLUxfJ59g/Bk7PpUoX9INYDvAcTyrwCa9w9MhkWTqfIw7hHZU+83EEZxQhLj/B/ts9UNespMjQz1vKrbASv6XiNjrBmAMGBdc33OqMGgMr4bABi2FcyVr"
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