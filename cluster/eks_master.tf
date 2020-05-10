resource "aws_eks_cluster" "eks_cluster" {
  name = var.eks_cluster_name
  role_arn = aws_iam_role.eks_master_role.arn

  vpc_config {
    security_group_ids = [aws_security_group.master_security_group.id]
    subnet_ids = [var.app_subnet_id0, var.app_subnet_id1]
//    subnet_ids = [var.application_subnets]
    public_access_cidrs = ["${var.accessing_computer_ip}/32"]
    endpoint_private_access = true
  }

  //  "${join("\",\"", aws_instance.workers.*.id)}"

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSServicePolicy,
  ]
}