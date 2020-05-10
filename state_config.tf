terraform {
  backend "s3" {
    region = "eu-west-1"
    bucket = "tfstatenigel"
    key = "eks-cluster.tfstate"
    encrypt = "false"
  }
}