#provider "aws" {
#  region = "var.region_name"
#  profile = "AWS_741032333307_User"
#}

provider "aws" {
  region     = var.region_name
  access_key = "ASIA2ZCHYB755TLIAMN2"
  secret_key = "Rk86ccmpBwjYfkM1+kXs30q7+RbJ9Ys9sOGSomJX"
  token      = "IQoJb3JpZ2luX2VjEHwaCXVzLWVhc3QtMSJIMEYCIQCtDXHOWu5HrZh5XDBaKRF3gcuVeXeBjbQskIyB8VcqmAIhAON5t+VPn2clUeIp1SOL6DsY1j5NoL0L4NQ5BazUfxJEKq8CCHQQAhoMNzQxMDMyMzMzMzA3IgwTn+J6HXCAAIRa1I0qjALR2L4D6MY+jF5DOMby0mwdTTTBnLcPn0Xz9/65Ve2zQ4TjcYRBn4AoKJvs0jLf4MEBQipJjiFTX0mvCt639fDYe0wuBsPP5cjsGp/9CEvjPgseuGz9Ibu9/0BGv6EC5lusLIYLkWkXDxFo8HLGMkfvUxMJ1Y6fh4IdKjRVPpsBrp47hHKGIfAUEEwu8Eghwz7RGhr25N00YVwP2Z8hb1L7/AOkjVoHmKzh2rOEH960gMFwNUhgjLj4v5aq6RnFgq5CmJRCvHz67/5NQJ+FEOm+D8BppWuT6B4MRrglAavEHx/gmSY3g/RVAhv2DV6XC2guKiThrI9WqCCwLB9SV0POR3q1IWbFUp2VqfcmMPTc55QGOpwBQNrlJo7PpeJgTS0irlsEAxqfAr3ZX8YPRHJRjxWudwxCmu8CpezQSEkQjHTQhaoIalDT1IaYHlMK2rTdhiEjJycqSEIJmr7SOX9BLcZszrPp/R7W7w2RgjUawMnWKH+ioa4JxutWK4x0LZ5MA2tv+XG945m982qcm6VgGMvGOef4cSYs7nZT1fZIEBexsfJGPUZdbPR7KJvetP7Q"
  #
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