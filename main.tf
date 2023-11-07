terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "eks_vpc" {
  source = "./modules/vpc"
}

module "eks_cluster" {
  source = "./modules/eks"

  vpc_id = module.eks_vpc.vpc_id
  cluster_region = var.region

  subnet_ids = module.eks_vpc.private_subnets
  fargate_subnet_ids = module.eks_vpc.private_subnets
}

