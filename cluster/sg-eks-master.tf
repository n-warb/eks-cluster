resource "aws_security_group" "master" {
  name = "cluster_ssecurity_group"
  description = "SG used for cluster communication with worker nodes"
  vpc_id = var.vpc_id

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = {
    Name = "${var.eks_cluster_name}-master_cluster_security_group"
  }
}