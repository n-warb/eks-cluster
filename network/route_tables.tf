resource "aws_route_table" "application" {
  count = var.subnet_count
  vpc_id = aws_vpc.eks-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks-cluster-nat-gw.*.id[count.index]
  }
  tags = {
    Name = "example_application"
  }
}


resource "aws_route_table" "gateway" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "example_gateway"
  }
}


resource "aws_route_table_association" "application" {
  count = var.subnet_count

  subnet_id = aws_subnet.application.*.id[count.index]
  route_table_id = aws_route_table.application.*.id[count.index]
}


resource "aws_route_table_association" "gateway" {
  count = var.subnet_count

  subnet_id = aws_subnet.gateway.*.id[count.index]
  route_table_id = aws_route_table.gateway.id
}