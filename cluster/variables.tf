variable "vpc_id" {
  description = "VPC to launch the cluster into"
}

variable "accessing_computer_ip" {
  description = "Public IP of the computer accessing the cluster via kubectl or browser."
}

variable "aws_region" {
  description = "Used AWS Region."
}

variable "application_subnets" {
}


variable "app_subnet_id0" {
}

variable "app_subnet_id1" {
}

variable "eks_cluster_name" {
  description = "The name to associated with this EKS cluster"
}

variable "keypair_name" {
  description = "The name of the keypair that can be used for EC2 access"
}

variable "cloudwatch_retention" {
  default = 7
  description = "The number of days to store cloudwatch cluster logs"
}

variable "enabled_cluster_log_types" {
  default = ["api", "audit", "authenticator"]
  description = "The cluster log types to store - see the following https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html"
}

variable "scaling_max_size" {
  default = 3
}

variable "scaling_min_size" {
  default = 1
}

variable "scaling_desired_size" {
  default = 2
}

variable "instance_type" {
  default = "t3.large"
}
