resource "aws_security_group" "node_security_group" {
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
    Name = "node_security_group"
  }
}