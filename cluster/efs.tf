resource "aws_efs_file_system" "eks_cluster_persistence" {
  creation_token = "eks-cluster-${var.eks_cluster_name}"

  tags = {
    Name = "eks-cluster-${var.eks_cluster_name}"
  }

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
}

resource "aws_efs_mount_target" "eks_cluster_persistence_target" {
  count = length(var.application_subnet_ids)
  file_system_id = aws_efs_file_system.eks_cluster_persistence.id
  subnet_id = var.application_subnet_ids[count.index]
  security_groups = [aws_security_group.node_ingress_efs.id]
}