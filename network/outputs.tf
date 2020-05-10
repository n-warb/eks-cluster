output "vpc_id" {
  value = aws_vpc.eks-vpc.id
}

output "subnet_application_0_id" {
  value = aws_subnet.application.0.id
}

output "application_subnets" {
  //  "${join("\",\"", aws_instance.workers.*.id)}"
  value = aws_subnet.application[*].id
}


output "subnet_application_1_id" {
  value = aws_subnet.application.1.id
}