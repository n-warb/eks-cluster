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
  application_subnet_ids = module.network.application_subnet_ids
  eks_cluster_name = var.eks_cluster_name
  keypair_name = var.keypair_name
}

module "keys" {
  source = "./keys"

  // pass variables from .tfvars
  keypair_name = var.keypair_name
}
