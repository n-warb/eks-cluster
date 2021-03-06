provider "aws" {
  region = var.aws_region
  version = "~> 2.61"
}

variable "aws_region" {
  default = "eu-west-1"
}

variable "subnet_count" {
  default = 2
}


variable "accessing_computer_ip" {
}


variable "eks_cluster_name" {
  default = "infrastructure-cluster"
}

variable "keypair_name" {
  default = "infrastructure-cluster-keypair"
}

