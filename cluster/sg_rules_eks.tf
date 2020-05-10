resource "aws_security_group_rule" "master_ingress_workstation_https" {
  cidr_blocks = [
    "${var.accessing_computer_ip}/32"]
  description = "Allow workstation to communicate with the cluster API Server."
  from_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.master_security_group.id
  to_port = 443
  type = "ingress"
}

resource "aws_security_group_rule" "node_ingress_workstation_https" {
  cidr_blocks = [
    "${var.accessing_computer_ip}/32"]
  description = "Allow workstation to communicate with the Kubernetes nodes directly."
  from_port = 22
  protocol = "tcp"
  security_group_id = aws_security_group.node_security_group.id
  to_port = 22
  type = "ingress"
}


# Setup worker node security group

resource "aws_security_group_rule" "node_ingress_self_all" {
  description = "Allow nodes to communicate with each other"
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.node_security_group.id
  source_security_group_id = aws_security_group.node_security_group.id
  to_port = 65535
  type = "ingress"
}

resource "aws_security_group_rule" "node_ingress_cluster" {
  description = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port = 1025
  protocol = "tcp"
  security_group_id = aws_security_group.node_security_group.id
  source_security_group_id = aws_security_group.master_security_group.id
  to_port = 65535
  type = "ingress"
}

# allow worker nodes to access EKS master
resource "aws_security_group_rule" "cluster_ingress_node_https" {
  description = "Allow pods to communicate with the cluster API Server"
  from_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.node_security_group.id
  source_security_group_id = aws_security_group.master_security_group.id
  to_port = 443
  type = "ingress"
}

resource "aws_security_group_rule" "node_ingress_master_https" {
  description = "Allow cluster control to receive communication from the worker Kubelets"
  from_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.master_security_group.id
  source_security_group_id = aws_security_group.node_security_group.id
  to_port = 443
  type = "ingress"
}