resource "aws_eks_cluster" "eks_cluster" {
  name = var.eks_cluster_name
  role_arn = aws_iam_role.eks_master_role.arn

  vpc_config {
    security_group_ids = [aws_security_group.master.id]
    //    subnet_ids = [var.app_subnet_id0, var.app_subnet_id1]
    subnet_ids = var.application_subnet_ids
    public_access_cidrs = ["${var.accessing_computer_ip}/32"]
    endpoint_private_access = true
  }

  enabled_cluster_log_types = var.enabled_cluster_log_types

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSServicePolicy,
    aws_cloudwatch_log_group.eks_cluster_cloudwatch
  ]
}


resource "aws_cloudwatch_log_group" "eks_cluster_cloudwatch" {
  name = "/aws/eks/${var.eks_cluster_name}/cluster"
  retention_in_days = var.cloudwatch_retention
}