resource "tls_private_key" "tf-key" {
  algorithm                   = "RSA"
  rsa_bits                    = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name                    = "tf-key"
  public_key                  = "${tls_private_key.tf-key.public_key_openssh}"
}

locals {
  module_base = "${var.debug ? ".." : "github.com/zironycho/swarm-aws-terraform//modules"}"
}

module "ami" {
  source                      = "${local.module_base}/ami"
}

module "vpc" {
  source                      = "${local.module_base}/vpc"
  vpc_cidr                    = "${var.vpc_cidr}"
  vpc_subnet_cidrs            = "${var.vpc_subnet_cidrs}"
}

module "bastion" {
  source                      = "${local.module_base}/bastion"
  vpc_id                      = "${module.vpc.id}"
  ami                         = "${module.ami.id}"
  subnet_id                   = "${module.vpc.az_subnet_ids[0]}"
  aws_key_name                = "${aws_key_pair.generated_key.key_name}"
  internal_security_group_id  = "${aws_security_group.swarm.id}"
}
