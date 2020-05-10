output "eks_kubeconfig" {
  value = local.kubeconfig
  depends_on = [
    aws_eks_cluster.eks_cluster]
}


output "node_sg_id" {
  value = aws_security_group.node_security_group.id
}

output image_id {
  value = data.aws_ami.worker_ami_definition.id
}