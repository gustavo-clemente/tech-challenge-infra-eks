module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "tech_challenge_cluster"
  cluster_version = "1.28"
  cluster_endpoint_public_access = true
  subnet_ids = var.subnet_ids
  control_plane_subnet_ids = var.subnet_ids
  vpc_id = var.vpc_id
  cluster_addons = {
    kube-proxy = {}
    vpc-cni    = {}
    coredns = {
      configuration_values = jsonencode({
        computeType = "Fargate"
      })
    }
  }

  fargate_profiles = {
    tech_challenge = {
      name = "tech-challenge"
      selectors = [
        {
          namespace = "api-tech-challenge"
        },
        {
          namespace = "monitoring-tech-challenge"
        },
        {
          namespace = "database-tech-challenge"
        },
        {
          namespace = "kube-system"
        }
      ]

      subnet_ids = var.fargate_subnet_ids
    }
  }
}

module "alb-controller" {
  source = "./alb-controller"
  depends_on = [module.eks]

  cluster_name = module.eks.cluster_name
  cluster_region = var.cluster_region
  vpc_id = var.vpc_id
  oidc_provider_arn = module.eks.oidc_provider_arn
}

module "ack-controller" {
  source = "./ack-controller"
  depends_on = [module.eks]

  cluster_name = module.eks.cluster_name
  cluster_region = var.cluster_region
  vpc_id = var.vpc_id
  oidc_provider_arn = module.eks.oidc_provider_arn
}