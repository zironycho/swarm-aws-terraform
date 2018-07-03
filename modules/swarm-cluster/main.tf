resource "tls_private_key" "tf-key" {
  algorithm                   = "RSA"
  rsa_bits                    = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name                    = "tf-key"
  public_key                  = "${tls_private_key.tf-key.public_key_openssh}"
}

module "ami" {
  source                      = "../ami"
}

module "vpc" {
  source                      = "../vpc"
  vpc_cidr                    = "${var.vpc_cidr}"
  vpc_subnet_cidrs            = "${var.vpc_subnet_cidrs}"
}

module "bastion" {
  source                      = "../bastion"
  vpc_id                      = "${module.vpc.id}"
  ami                         = "${module.ami.id}"
  subnet_id                   = "${module.vpc.az_subnet_ids[0]}"
  aws_key_name                = "${aws_key_pair.generated_key.key_name}"
  internal_security_group_id  = "${aws_security_group.swarm.id}"
}

locals {
  frontend_host = "${var.frontend_host == "" ? aws_lb.frontend.dns_name : var.frontend_host}"
}