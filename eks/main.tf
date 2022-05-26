

/* =====================
Creating EKS Cluster 
========================*/


resource "aws_eks_cluster" "eks_cluster" {
  name     = substr("${var.cluster_name}-${var.environment}",0,64)
   
  role_arn = aws_iam_role.eks_cluster_role.arn
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  version  = var.cluster_version
  
   vpc_config {
    subnet_ids =  concat(var.public_subnets, var.private_subnets)
  }
   
   timeouts {
     delete    =  "30m"
   }
  
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy1,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController1,
    aws_cloudwatch_log_group.cloudwatch_log_group
  ]
}


/* ==================================
Creating IAM Policy for EKS Cluster 
=====================================*/
resource "aws_iam_policy" "AmazonEKSClusterCloudWatchMetricsPolicy" {
  name   = substr("${var.cluster_name}-${var.environment}-AmazonEKSClusterCloudWatchMetricsPolicy",0,64)
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "cloudwatch:PutMetricData"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

/* ==================================
Creating IAM Role for EKS Cluster 
=====================================*/

resource "aws_iam_role" "eks_cluster_role" {
  name = substr("${var.cluster_name}-${var.environment}-cluster-role",0,64)
  description = "Allow cluster to manage node groups, fargate nodes and cloudwatch logs"
  force_detach_policies = true
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [       
           "eks.amazonaws.com",
          "eks-fargate-pods.amazonaws.com"
          ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy1" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSCloudWatchMetricsPolicy" {
  policy_arn = aws_iam_policy.AmazonEKSClusterCloudWatchMetricsPolicy.arn
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController1" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = "/aws/eks/${var.cluster_name}-${var.environment}/cluster"
  retention_in_days = 30

  tags = {
    Name        = "${var.cluster_name}-${var.environment}-eks-cloudwatch-log-group"
  }
}


/* =======================================
Creating Fargate Profile for Applications
==========================================*/

resource "aws_eks_fargate_profile" "eks_fargate_app" {
  cluster_name           = aws_eks_cluster.eks_cluster.name
  fargate_profile_name   = substr("${var.cluster_name}-${var.environment}-app-fargate-profile",0,64)
  pod_execution_role_arn = aws_iam_role.eks_fargate_role.arn
  subnet_ids             = var.private_subnets

  selector {
    namespace = var.fargate_app_namespace
  }

  timeouts {
    create   = "30m"
    delete   = "30m"
  }
}

/* =======================================
Creating IAM Role for Fargate profile
==========================================*/

resource "aws_iam_role" "eks_fargate_role" {
  name = "${var.cluster_name}-fargate_cluster_role"
  description = "Allow fargate cluster to allocate resources for running pods"
  force_detach_policies = true
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [ 
           "eks.amazonaws.com",
          "eks-fargate-pods.amazonaws.com"
          ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.eks_fargate_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_fargate_role.name
}


resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_fargate_role.name
}



/* =======================================
Creating Fargate Profile for CoreDNS
==========================================*/

resource "aws_eks_fargate_profile" "eks_fargate_system" {
  cluster_name           = aws_eks_cluster.eks_cluster.name
  fargate_profile_name   = substr("${var.cluster_name}-${var.environment}-system-fargate-profile",0,64)
  pod_execution_role_arn = aws_iam_role.eks_fargate_system_role.arn
  subnet_ids             = var.private_subnets

  selector {
    namespace = "kube-system"
  }
  selector {
    namespace = "default"
  }
  timeouts {
    create   = "30m"
    delete   = "30m"
  }
}

/* ===========================================
Creating IAM Role for Fargate profile CoreDNS
==============================================*/

resource "aws_iam_role" "eks_fargate_system_role" {
  name = substr("${var.cluster_name}-eks_fargate_system_role",0,64)
  description = "Allow fargate cluster to allocate resources for running pods"
  force_detach_policies = true
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [ 
           "eks.amazonaws.com",
          "eks-fargate-pods.amazonaws.com"
          ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSFargatePodExecutionRolePolicy2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.eks_fargate_system_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_fargate_system_role.name
}


resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_fargate_system_role.name
}



################################################################################
# IRSA
# Note - this is different from EKS identity provider
################################################################################

data "tls_certificate" "auth" {
  url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = concat([data.tls_certificate.auth.certificates[0].sha1_fingerprint])
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer

  tags = {  Name  = "${var.cluster_name}-${var.environment}-eks-irsa" }
}



#resource "aws_eks_node_group" "eks_node_group" {
#  cluster_name    = aws_eks_cluster.eks_cluster.name
#  node_group_name = "${var.cluster_name}-${var.environment}-node_group"
#  node_role_arn   = aws_iam_role.eks_node_group_role.arn
#  subnet_ids      = var.public_subnets
#
#  scaling_config {
#    desired_size = 2
#    max_size     = 3
#    min_size     = 2
#  }
#
#  instance_types  = ["${var.eks_node_group_instance_types}"]
#
#  depends_on = [
#    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
#    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
#    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
#  ]
#}
#
#resource "aws_iam_role" "eks_node_group_role" {
#  name = "${var.cluster_name}-node-group_role"
#
#  assume_role_policy = jsonencode({
#    Statement = [{
#      Action = "sts:AssumeRole"
#      Effect = "Allow"
#      Principal = {
#        Service = "ec2.amazonaws.com"
#      }
#    }]
#    Version = "2012-10-17"
#  })
#}
#
#resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#  role       = aws_iam_role.eks_node_group_role.name
#}
#
#resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#  role       = aws_iam_role.eks_node_group_role.name
#}
#
#resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#  role       = aws_iam_role.eks_node_group_role.name
#}



