# Setup data source to get amazon-provided AMI for EKS nodes
# The latest images from AWS can be found here:
# https://docs.aws.amazon.com/eks/latest/userguide/eks-optimized-ami.html
# if we set values: "amazon-eks-node-*" then the image grabbed will be K8s version 1.12.10
data "aws_ami" "worker_ami_definition" {
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
/etc/eks/bootstrap.sh '${var.eks_cluster_name}' --apiserver-endpoint '${aws_eks_cluster.eks_cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks_cluster.certificate_authority.0.data}'
USERDATA
}

//AMI ID obtained from here: https://docs.aws.amazon.com/eks/latest/userguide/eks-optimized-ami.html
//This is for eu-west-1:

resource "aws_launch_configuration" "cluster_launch_config" {
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.node_profile.name
  image_id = data.aws_ami.worker_ami_definition.id
  instance_type = "t3.large"
  name_prefix = "terraform-eks"
  security_groups = [aws_security_group.node_security_group.id]
  user_data_base64 = base64encode(local.tf-eks-node-userdata)
  key_name = var.keypair_name

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "cluster_autoscaling_config" {
  desired_capacity = "2"
  launch_configuration = aws_launch_configuration.cluster_launch_config.id
  health_check_grace_period = 300
  max_size = "3"
  min_size = "1"
  name = "terraform-tf-eks"
  vpc_zone_identifier = [var.app_subnet_id0, var.app_subnet_id1]

  //  "${join("\",\"", aws_instance.workers.*.id)}"
  tag {
    key = "kubernetes.io/cluster/${var.eks_cluster_name}"
    value = "owned"
    propagate_at_launch = true
  }

  tag {
    key = "k8s.io/cluster-autoscaler/${var.eks_cluster_name}"
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