# aws --version
# aws eks --region us-east-1 update-kubeconfig --name congdang-cluster
# Uses default VPC and Subnet. Create Your Own VPC and Private Subnets for Prod Usage.
# terraform-backend-state-congdang-123
# AKIA4AHVNOD7OOO6T4KI


terraform {
  backend "s3" {
    bucket = "mybucket" # Will be overridden from build
    key    = "path/to/my/key" # Will be overridden from build
    region = "ap-southeast-1"
  }
}

resource "aws_default_vpc" "default" {

}

data "aws_subnet_ids" "subnets" {
  vpc_id = aws_default_vpc.default.id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  # load_config_file       = false
 // version                = "~> 1.9"
}

module "congdang-cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "congdang-cluster"
  cluster_version = "1.17"
  subnet_ids         = ["subnet-2afc2062", "subnet-4c4ee22a"] #CHANGE # Donot choose subnet from us-east-1e
  #subnets = data.aws_subnet_ids.subnets.ids
  vpc_id          = aws_default_vpc.default.id
  #vpc_id         = "vpc-1234556abcdef"

  # node_groups = [
  #   {
  #     instance_type = "t2.micro"
  #     max_capacity  = 5
  #     desired_capacity = 3
  #     min_capacity  = 3
  #   }
  # ]

  # Self Managed Node Group(s)
  self_managed_node_group_defaults = {
    instance_type                          = "t2.micro"
    update_launch_template_default_version = true
    iam_role_additional_policies = [
      "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    ]
  }

  self_managed_node_groups = {
    one = {
      name         = "mixed-1"
      max_size     = 5
      desired_size = 2

      use_mixed_instances_policy = true
      mixed_instances_policy = {
        instances_distribution = {
          on_demand_base_capacity                  = 0
          on_demand_percentage_above_base_capacity = 10
          spot_allocation_strategy                 = "capacity-optimized"
        }

        override = [
          {
            instance_type     = "t2.micro"
            weighted_capacity = "1"
          },
          {
            instance_type     = "t2.micro"
            weighted_capacity = "2"
          },
        ]
      }
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    disk_size      = 50
    instance_types = ["t2.micro"]
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["t2.micro"]
      capacity_type  = "SPOT"
    }
  }

  # Fargate Profile(s)
  fargate_profiles = {
    default = {
      name = "default"
      selectors = [
        {
          namespace = "default"
        }
      ]
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.congdang-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.congdang-cluster.cluster_id
}


# We will use ServiceAccount to connect to K8S Cluster in CI/CD mode
# ServiceAccount needs permissions to create deployments
# and services in default namespace
resource "kubernetes_cluster_role_binding" "example" {
  metadata {
    name = "fabric8-rbac"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "default"
  }
}

# Needed to set the default region
provider "aws" {
  region  = "ap-southeast-1"
}