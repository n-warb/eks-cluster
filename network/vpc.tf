resource "aws_vpc" "eks-vpc" {
  cidr_block = var.cidr-range
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = map( "Name", "infrastructure-eks",
  "kubernetes.io/cluster/example", "shared", )
}



