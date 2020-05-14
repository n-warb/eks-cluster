resource "tls_private_key" "private_access" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.keypair_name
  public_key = tls_private_key.private_access.public_key_openssh
}