output "eks_kubeconfig" {
  value = module.cluster.eks_kubeconfig
  depends_on = [
    aws_eks_cluster.tf_eks]
}