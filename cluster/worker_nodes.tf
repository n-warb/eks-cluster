# Setup data source to get amazon-provided AMI for EKS nodes
# The latest images from AWS can be found here:
# https://docs.aws.amazon.com/eks/latest/userguide/eks-optimized-ami.html
# if we set values: "amazon-eks-node-*" then the image grabbed will be K8s version 1.12.10
data "aws_ami" "worker_ami_definition" {
  filter {
    name = "name"
    values = ["amazon-eks-node-1.15*"]
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
  node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
echo '${var.eks_cluster_name}'
# Install the Session Manager Agent to SSH into the EKS nodes.
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl enable amazon-ssm-agent
systemctl restart amazon-ssm-agent
/etc/eks/bootstrap.sh '${var.eks_cluster_name}' --enable-docker-bridge true --apiserver-endpoint '${aws_eks_cluster.eks_cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks_cluster.certificate_authority.0.data}'
# after the bootstrap, restart the kubelet service (this will allow the nodes to connect to the cluster)
systemctl restart kubelet.service
USERDATA
}

//AMI ID obtained from here: https://docs.aws.amazon.com/eks/latest/userguide/eks-optimized-ami.html
//This is for eu-west-1:

resource "aws_launch_configuration" "cluster" {
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.node_profile.name
  image_id = data.aws_ami.worker_ami_definition.id
  instance_type = var.instance_type
  name_prefix = "eks-cluster-${var.eks_cluster_name}"
  security_groups = [aws_security_group.node.id]
  user_data_base64 = base64encode(local.node-userdata)
  key_name = var.keypair_name

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "cluster" {
  desired_capacity = var.scaling_desired_size
  launch_configuration = aws_launch_configuration.cluster.id
  health_check_grace_period = 300
  max_size = var.scaling_max_size
  min_size = var.scaling_min_size
  name = "${var.eks_cluster_name}-autoscaling"
  vpc_zone_identifier = var.application_subnet_ids

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
    value = "${var.eks_cluster_name}-autoscaling"
    propagate_at_launch = true
  }

  tag {
    key = "role"
    value = "eks-worker"
    propagate_at_launch = true
  }

  tag {
    key = "k8s.io/cluster-autoscaler/enabled"
    value = "true"
    propagate_at_launch = true
  }
}