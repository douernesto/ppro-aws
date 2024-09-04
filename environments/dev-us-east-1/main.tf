locals {
  tags = {
    Source      = "ppro-aws"
    Environment = "dev"
  }
}

module "eks" {
  source = "../../modules/eks/"

  eks_name           = "ppro-dev"
  kubernetes_version = "1.30"

  private_subnet_count = 2
  vpc_cidr_block       = "10.0.0.0/16"
  capacity_type        = "ON_DEMAND"
  instance_types       = ["t2.small"]

  scaling_config = {
    desired_size : 1
    max_size : 5
    min_size : 0
  }

  labels = {
    node-type : "general"
  }

  # taints = [
  #   {
  #     key    = "CriticalAddonsOnly",
  #     value  = "true",
  #     effect = "NO_SCHEDULE"
  #   }
  # ]

}
