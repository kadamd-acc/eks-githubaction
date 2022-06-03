

provider "aws" {
  region     = var.region_name
  access_key = "ASIA2ZCHYB756H3JX54Y"
  secret_key = "VK50j/+hXnWdpDNRe/y49N7yEzlVmQbmWYNad8LK"
  token      = "IQoJb3JpZ2luX2VjEHYaCXVzLWVhc3QtMSJHMEUCIQDC/eMxmHY0uaH+Hf9u4iiufcPizjTRWrXtnAVafUpTkAIgBt7EZntZudm7zRM4GnKXhzrFfLXbkDtUmzCta+gQKPEqrwIIbxACGgw3NDEwMzIzMzMzMDciDNKb6KIuuFJsv7DlOiqMAj8ScqSpr0rVYDsK6a7cpruHfhmyePmOQlakQEAJTahK/eLtUd3VhtWbwVDEX0lSURC56BpPrrL0o9QgAhOvlBPRtF+m8wxYTuRY1uZHsif3CUAKl1NuHTKUlqg/biAlDhx6iNsHCKrmru1ctzYZrduKB4MNQT1NMmRqusaFRG2YaF5pEcrZqqWSmi65sohQE82V5DJfy2oTIkAT2K8cwo6LJ6z+uGbFR2NmtmojWMdWsHjRM2P7OqUIzP/QX+6dHEilrOffh5v6dUeruL5YBcdJ/PaClYw4AcP6eaKWOupDg7ZK+Qt3s3SNVGPnFT4whFEuGDY1vLAEa+LJI/9qnk0QAXEjr7dRrEFXH4Mw7rXmlAY6nQG3zHfuw64cwojiMK44bvVsbXyYbRbMtk3lZD+Solgm/ALkTR+MZ/UfnhpdpxG06x3wtR1O/V/UKOlrq/AWzdi65dUCSMYN1aQbOfgIO69eco5hdPdC+QfMRRhzACD5UBRk7H5nB45/tcYsX5j+QPfErFCTuCRgVAs6ML9BOzLJiyCZVz2hXp8ELKT+2Eq1GA34/3/tcTpcT/qmU6hG"
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