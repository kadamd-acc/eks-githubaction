#provider "aws" {
#  region = "var.region_name"
#  profile = "AWS_741032333307_User"
#}

provider "aws" {
  region     = var.region_name
  access_key = "ASIA2ZCHYB755GLYZIWQ"
  secret_key = "ke2TZ4c7Pi1wg1cRSimV8034vFl1dP1uxakygFX8"
  token      = "IQoJb3JpZ2luX2VjEHwaCXVzLWVhc3QtMSJHMEUCIEMRz8pFs+FLX+pT5AZBkccdj1KH/X1XJQ7kCgiuOqCaAiEA4sRTkasDh2Sc8LImj2UTXbQIDfhBegz4i3SICEH/hYQqrwIIdBACGgw3NDEwMzIzMzMzMDciDDul+R1aOef8SEyaASqMAnDMO5hHjSH+g9/IzRbzqC7sOb+7Jq8igycC/F2IR2bqzCXomJaC/lszTrYzDoA4I625eNZ0eTOzjxFDTZwY1CJbAHJPcCvZzt5JQBr7jNjH4UYNVFHLs0vc92k5pwijgjo9ew06Mq6oK1l414cL4OH5p15iMJRXmsXXlLaRBo+7zlCsecMfjnc2C0Yo0reHZV4g14t96NRLkLBhcvfBBLeVsDULc2CtkbJZSptOytuyGEEN/FBdJdMI/wIceja3htl/wP+XHI7/Jjw5J3deP6ultNqYP6q5yYZrqOu3sedEPCgeIikbIncqFF1s09GAy7LOVQJvFw7stWm1pzaWf1TFBkiobR3O3CzIEEMwk9bnlAY6nQEt6OxosMnDayhkYkMvdL3MV0ST1Ean4T2Ik+Pgwr78W50NaGiWDZWrtynejnGKNKTA4VGCMkDmjzvTJNXFWpWUe4eNWR/U8uxjGub5S0hMOA1EjKkYjrWb+7YK+YVm2dkyXdEfiF5mlmUmt7sG9FG8RVJUWug+C8JfPRQYQlls19f/pu8fr2aDiAJEzFOPaXE8wBMtJYlK/8TZSXdt"
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