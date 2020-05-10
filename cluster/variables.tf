variable "vpc_id" {
}

variable "accessing_computer_ip" {
  description = "Public IP of the computer accessing the cluster via kubectl or browser."
}

variable "aws_region" {
  description = "Used AWS Region."
}

variable "app_subnet" {
}


variable "app_subnet_id0" {
}

variable "app_subnet_id1" {
}

variable "eks_cluster-name" {
}

variable "keypair-name" {
}

