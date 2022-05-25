


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
    environment                         =  var.environment
    eks_node_group_instance_types       =  var.eks_node_group_instance_types
    private_subnets                     =  module.vpc.aws_subnets_private
    public_subnets                      =  module.vpc.aws_subnets_public
    fargate_namespace                   =  var.fargate_namespace

    depends_on = [module.vpc]
}

/*
module "load_balancer_controller" {
  source = "./aws-lb-controller"

  enabled = true

  cluster_identity_oidc_issuer     = module.eks.oidc_provider  #eks_cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  cluster_name                     = module.eks.eks_cluster_id

  depends_on = [module.eks]
}
*/

/*
module "new_load_balancer_controller" {
  source = "./new-aws-lb-controller"

  #enabled = true

  cluster_identity_oidc_issuer_url     = module.eks.oidc_provider  #eks_cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  cluster_name                     = module.eks.eks_cluster_id
  environment                      =  var.environment
  depends_on = [module.eks]

}
*/




data "aws_region" "current" {}


data "aws_eks_cluster" "target" {
  name = module.eks.eks_cluster_name
}

data "aws_eks_cluster_auth" "aws_iam_authenticator" {
  name = data.aws_eks_cluster.target.name
}

provider "kubernetes" {
  alias = "eks"
  host                   = data.aws_eks_cluster.target.endpoint
  token                  = data.aws_eks_cluster_auth.aws_iam_authenticator.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.target.certificate_authority[0].data)
  #load_config_file       = false
}

provider "helm" {
  alias = "eks"
  kubernetes {
    host                   = data.aws_eks_cluster.target.endpoint
    token                  = data.aws_eks_cluster_auth.aws_iam_authenticator.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.target.certificate_authority[0].data)
  }
}


module "alb_controller" {
  source  = "./another-lb-controller"
  #version = "3.4.0"

  providers = {
    kubernetes = "kubernetes.eks",
    helm       = "helm.eks"
  }

  k8s_cluster_type = "eks"
  k8s_namespace    = "kube-system"

  aws_region_name  = data.aws_region.current.name
  k8s_cluster_name = data.aws_eks_cluster.target.name
  alb_controller_depends_on = ""
  depends_on = [module.eks]
}







 #---------------------------------------------
# Deploy Kubernetes Add-ons with sub module
#---------------------------------------------
/*
module "eks_kubernetes_addons" {
  source         = "./kubernetes-addons"
  eks_cluster_id = module.eks.eks_cluster_id

  # EKS Managed Add-ons
  #enable_amazon_eks_coredns    = true
  #enable_amazon_eks_kube_proxy = true

  # K8s Add-ons
  enable_aws_load_balancer_controller = true
  #enable_metrics_server               = true
  #enable_cluster_autoscaler           = true
  #enable_aws_efs_csi_driver           = true

  depends_on = [module.eks.eks_cluster_id]
}
*/



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
