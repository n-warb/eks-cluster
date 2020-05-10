module "network" {
  source = "./network"

  // pass variables from .tfvars
  aws_region = var.aws_region
  subnet_count = var.subnet_count
  cluster-name = var.eks-cluster-name
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
  eks_cluster-name = var.eks-cluster-name
  app_subnet = module.network.subnet_application
  keypair-name = var.keypair-name
}

module "keys" {
  source = "./keys"

  keypair-name = var.keypair-name
}
