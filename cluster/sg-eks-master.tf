resource "aws_security_group" "master_security_group" {
  name = "cluster-sg"
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
    Name = "cluster-sg"
  }
}