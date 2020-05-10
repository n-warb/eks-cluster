data "aws_availability_zones" "available" {
  state = "available"
}


resource "aws_subnet" "gateway" {
  count = var.subnet_count
  availability_zone = data.aws_availability_zones.available.names[count.index]
  //Allocate cidr_range + 8 bits
  //e.g if cidr_range = /16 then add 8 bits giving /24 range
  //this would give 256 - 5 (allocated for AWS use) = 251 possible.
  cidr_block = cidrsubnet(var.cidr-range, 8, count.index)
  vpc_id = aws_vpc.eks-vpc.id
  tags = map("Name", "internet-gateway-${count.index}")
}

resource "aws_subnet" "application" {
  count = var.subnet_count
  availability_zone = data.aws_availability_zones.available.names[count.index]
  //Allocate cidr_range + 8 bits
  //e.g if cidr_range = /16 then add 8 bits giving /24 range
  //this would give 256 - 5 (allocated for AWS use) = 251 possible.
  //start the range immediately after gateway
  cidr_block = cidrsubnet(var.cidr-range, 8, (count.index+length(aws_subnet.gateway)))

  //  cidr_block = "10.0.2${count.index}.0/24"
  vpc_id = aws_vpc.eks-vpc.id
  //The kubernetes.io/cluster/name is used by AWS to determine that the subnet
  //is appropriate for use by the cluster. Without this tag, the nodes
  //cannot be added to the cluster
  tags = map( "Name", "eks-cluster-node-subnet-${count.index}",
  "kubernetes.io/cluster/${var.cluster-name}", "shared", )
}