#provider "aws" {
#  region = "var.region_name"
#  profile = "AWS_741032333307_User"
#}

provider "aws" {
  region     = var.region_name
  access_key = "ASIA2ZCHYB75SZIKQY55"
  secret_key = "kPCgo8sxmg5koOom2NhsbqOssDeGDpNV+S60URIH"
  token      = "IQoJb3JpZ2luX2VjEMD//////////wEaCXVzLWVhc3QtMSJHMEUCIQDHMV/2uHqem54wb+ALfdnAbfgB2YgKO7gDSPWuYp+2rwIgCCDJ+PfFlYDWIuY+AHoT/gLd8y7M44D1AdbOUSEpf2oquAIIuf//////////ARACGgw3NDEwMzIzMzMzMDciDOzJgUawaxp7OMAsHSqMAqfraSBkX1GkLUFkdBrtNQ+BHZjpScJ4ZBVapLwKU7yooTC/vUEfDBS0AGnQXcXHXEbnwXyPIKhD5/ucxF7odjebN42h74vChOoIV5APBd68Cq826+41Lx/xJ1V2X7t6Zz8rhsSfhu8g8vY2+vMG8RKVKs+jWCwJOI/GBF7PpnrdmezkFfcQhV2QLw4f6popdmsfVfgjpam3tQgwO57bBQxNXJaeOCm190G05KPe+ecRIcJzjlyVALZDAi/zmLgXaQlGpeQ4KA7kIGy0USmp5tOdWXTmOBt7azqpa60cxRXS7oIXyI/OXok+oQYlmNSfDgY+c4Qzuy7kKXuuXeU0BaHb1zztW2ntsFXqFl8wkdn2lAY6nQHPrYcsRkgZSNJMoRxkv3dK2RUWrpnJ8PehgKgcQNv74qsGTqtwbvnudC8vZVNwN9Sdyag1oz9u07wURy21V21hg3hp5ixLdDNHV93hFGK5CPXfjRZDKz4tv9gj4+7hFa5V+Lv+sCZA3HTFBfce5/aYltrRt7HMF76sz+IZ5y4W6WFBHRWv3gHeZvIFZUuKEmjinOm1bSHc5V+iUQDP"
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