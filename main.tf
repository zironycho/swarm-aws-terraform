provider "aws" {
  region = "${var.region}"
}

resource "tls_private_key" "tf-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name      = "tf-key"
  public_key    = "${tls_private_key.tf-key.public_key_openssh}"
}
