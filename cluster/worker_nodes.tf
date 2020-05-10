# Setup data source to get amazon-provided AMI for EKS nodes
data "aws_ami" "eks-worker" {
  filter {
    name = "name"
    values = ["amazon-eks-node-*"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "is-public"
    values = [true]
  }

  most_recent = true
  owners = ["602401143452"]
  # Amazon EKS AMI Account ID
}


# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We utilize a Terraform local here to simplify Base64 encode this
# information and write it into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  tf-eks-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh '${var.eks_cluster-name}' --apiserver-endpoint '${aws_eks_cluster.tf_eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.tf_eks.certificate_authority.0.data}'
USERDATA
}

//AMI ID obtained from here: https://docs.aws.amazon.com/eks/latest/userguide/eks-optimized-ami.html
//This is for eu-west-1:

resource "aws_launch_configuration" "tf_eks" {
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.node.name
  image_id = data.aws_ami.eks-worker.id
  instance_type = "t3.large"
  name_prefix = "terraform-eks"
  security_groups = [aws_security_group.tf-eks-node.id]
  user_data_base64 = base64encode(local.tf-eks-node-userdata)
  key_name = var.keypair-name

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "tf_eks" {
  desired_capacity = "2"
  launch_configuration = aws_launch_configuration.tf_eks.id
  health_check_grace_period = 300
  max_size = "3"
  min_size = "1"
  name = "terraform-tf-eks"
  vpc_zone_identifier = [var.app_subnet_id0, var.app_subnet_id1]

  //  "${join("\",\"", aws_instance.workers.*.id)}"
  tag {
    key = "kubernetes.io/cluster/${var.eks_cluster-name}"
    value = "owned"
    propagate_at_launch = true
  }

  tag {
    key = "k8s.io/cluster-autoscaler/${var.eks_cluster-name}"
    value = "owned"
    propagate_at_launch = true
  }

  tag {
    key = "k8s.io/cluster-autoscaler/enabled"
    value = "true"
    propagate_at_launch = true
  }


  tag {
    key = "Name"
    value = "terraform-tf-eks"
    propagate_at_launch = true
  }

}