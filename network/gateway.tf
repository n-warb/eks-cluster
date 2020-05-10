resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.eks-vpc.id

  tags = {
    Name = "eks-vpc-gw"
  }
}


resource "aws_eip" "nat_gateway" {
  count = var.subnet_count
  vpc = true
}


resource "aws_nat_gateway" "eks-cluster-nat-gw" {
  count = var.subnet_count
  allocation_id = aws_eip.nat_gateway.*.id[count.index]
  subnet_id = aws_subnet.gateway.*.id[count.index]
  tags = {
    Name = "eks-cluster-nat-gateway"
  }
  depends_on = [
    aws_internet_gateway.internet_gateway]
}
