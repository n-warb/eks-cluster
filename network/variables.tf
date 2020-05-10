variable "aws_region" {
  description = "Used AWS Region."
}

variable "subnet_count" {
  default = 2
}

variable "cluster-name" {
}

variable "cidr-range" {
  default = "10.0.0.0/16"
}