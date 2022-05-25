


module "vpc" {
    source                              = "./vpc"
    environment                         =  var.environment
    vpc_cidr                            =  var.vpc_cidr
    vpc_name                            =  var.vpc_name
    cluster_name                        =  var.cluster_name
    cluster_group                       =  var.cluster_group
    public_subnets_cidr                 =  var.public_subnets_cidr
    availability_zones_public           =  var.availability_zones_public
    private_subnets_cidr                =  var.private_subnets_cidr
    availability_zones_private          =  var.availability_zones_private
    cidr_block_nat_gw                   =  var.cidr_block_nat_gw
    cidr_block_internet_gw              =  var.cidr_block_internet_gw
}



module "eks" {
    source                              =  "./eks"
    cluster_name                        =  var.cluster_name
    cluster_version                     =  var.cluster_version
    environment                         =  var.environment
    eks_node_group_instance_types       =  var.eks_node_group_instance_types
    private_subnets                     =  module.vpc.aws_subnets_private
    public_subnets                      =  module.vpc.aws_subnets_public
    fargate_app_namespace               =  var.fargate_app_namespace

    depends_on = [module.vpc]
}


data "aws_region" "current" {}


data "aws_eks_cluster" "eks_cluster" {
  name = module.eks.eks_cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "aws_iam_authenticator" {
  name = data.aws_eks_cluster.eks_cluster.name
  depends_on = [module.eks]
}

provider "kubernetes" {
 # alias = "eks"
  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  token                  = data.aws_eks_cluster_auth.aws_iam_authenticator.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
}

provider "helm" {
  #alias = "eks"
  kubernetes {
    host                   = data.aws_eks_cluster.eks_cluster.endpoint
    token                  = data.aws_eks_cluster_auth.aws_iam_authenticator.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    config_path = "~/.kube/config"
  }
}


module "alb_controller" {
  source  = "./aws-lb-controller"
/*
  providers = {
    kubernetes = "kubernetes.eks",
    helm       = "helm.eks"
  }
  */

  k8s_cluster_type = "eks"
  k8s_namespace    = "kube-system"

  aws_region_name  = data.aws_region.current.name
  k8s_cluster_name = data.aws_eks_cluster.eks_cluster.name
  alb_controller_depends_on =  ""
  depends_on = [module.eks]
}










#module "kubernetes" {
#    source                              =  "./kubernetes"
#    cluster_id                          =  module.eks.cluster_id    
#    vpc_id                              =  module.vpc.vpc_id
#    cluster_name                        =  module.eks.cluster_name
#}




#
#module "database" {
#    source                              =  "./database"
#    secret_id                           =  var.secret_id
#    identifier                          =  var.identifier
#    allocated_storage                   =  var.allocated_storage
#    storage_type                        =  var.storage_type
#    engine                              =  var.engine
#    engine_version                      =  var.engine_version
#    instance_class                      =  var.instance_class
#    database_name                       =  var.database_name
#    environment                         =  var.environment
#    vpc_id                              =  module.vpc.vpc_id
#    private_subnets                     =  module.vpc.aws_subnets_private
#}
