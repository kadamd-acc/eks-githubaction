environment                  =  "testing"
user_profile                 =  "AWS_741032333307_User"
user_os                      =  "windows"
cluster_name                 =  "acn-eks-clstr"
cluster_version              =  "1.22"
cluster_type                 =  "eks"
cluster_group                =  "eks-fargate"
vpc_cidr                     =  "192.168.0.0/16"
vpc_name                     =  "eks-vpc"
region_name                  =  "eu-west-2"
public_subnets_cidr          =  ["192.168.0.0/24", "192.168.1.0/24", "192.168.2.0/24"]
private_subnets_cidr         =  ["192.168.4.0/24", "192.168.5.0/24", "192.168.6.0/24"]
availability_zones_public    =  ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
availability_zones_private   =  ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
cidr_block_internet_gw       =  "0.0.0.0/0"
cidr_block_nat_gw            =  "0.0.0.0/0"
eks_node_group_instance_types=  "t2.micro"
fargate_app_namespace        =  "ns-fargate-app"
secret_id                    =  "database"
identifier                   =  "database"
allocated_storage            =  20
storage_type                 =  "gp2"
engine                       =  "mysql"
engine_version               =  5.7
instance_class               =  "db.t2.micro"
database_name                =  "db"
