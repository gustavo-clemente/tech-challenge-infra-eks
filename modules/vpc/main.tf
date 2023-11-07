module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "eks_vpc"
  cidr = "10.0.0.0/16"

  azs                = ["us-west-2a", "us-west-2b"]
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.3.0/24", "10.0.4.0/24"]
  enable_nat_gateway = true

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/tech_challenge_cluster" = "shared"
  }

  enable_dns_hostnames = true
  enable_dns_support   = true
}