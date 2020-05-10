module "network" {
  source = "./network"

  // pass variables from .tfvars
  aws_region = var.aws_region
  subnet_count = var.subnet_count
  cluster-name = var.eks_cluster_name
}


module "cluster" {
  source = "./cluster"

  // pass variables from .tfvars
  accessing_computer_ip = var.accessing_computer_ip
  aws_region = var.aws_region
  // inputs from modules
  vpc_id = module.network.vpc_id
  app_subnet_id0 = module.network.subnet_application_0_id
  app_subnet_id1 = module.network.subnet_application_1_id
  application_subnets = module.network.application_subnets
  eks_cluster_name = var.eks_cluster_name
  keypair_name = var.keypair_name
}

module "keys" {
  source = "./keys"

  // pass variables from .tfvars
  keypair_name = var.keypair_name
}
