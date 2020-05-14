output "vpc_id" {
  value = aws_vpc.eks-vpc.id
}


output "application_subnet_ids" {
  value = aws_subnet.application[*].id
}


