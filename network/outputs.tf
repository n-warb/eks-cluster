output "vpc_id" {
  value = aws_vpc.eks-vpc.id
}

output "subnet_application_0_id" {
  value = aws_subnet.application.0.id
}

output "subnet_application" {
  value = aws_subnet.application.*
}


output "subnet_application_1_id" {
  value = aws_subnet.application.1.id
}