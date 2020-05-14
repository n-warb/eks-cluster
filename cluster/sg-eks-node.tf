resource "aws_security_group" "node" {
  name = "node_security_group"
  description = "Security group for all nodes in the cluster"
  vpc_id = var.vpc_id

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = {
    Name = "node_security_group-${var.eks_cluster_name}"
  }
}

resource "aws_security_group" "node_ingress_efs" {
  name = "node_ingress_efs"
  description = "Ingress rules for EFS for nodes"
  vpc_id = var.vpc_id
  // NFS
  ingress {
    security_groups = [aws_security_group.node.id]
    from_port = 2049
    to_port = 2049
    protocol = "tcp"
  }

  // Terraform removes the default rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
  }

  tags = {
    Name = "node_ingress_efs-${var.eks_cluster_name}"
  }


}