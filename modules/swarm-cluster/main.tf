resource "tls_private_key" "tf-key" {
  algorithm                   = "RSA"
  rsa_bits                    = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name                    = "${var.name_key}-${random_string.default.result}"
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
  frontend_host = "${var.route53_enabled ? var.route53_record_name : aws_lb.frontend.dns_name}"
  az_count = "${length(module.vpc.az_subnet_ids)}"
}

data "aws_region" "current" {}

data "template_file" "docker_init" {
  template = "${file("${path.module}/scripts/docker-init.tpl")}"
  
  vars {
    AWS_REGION        = "${data.aws_region.current.name}"
    AWS_ACCESSKEY     = "${var.aws_accesskey}"
    AWS_SECRETKEY     = "${var.aws_secretkey}"
    QUAY_USERNAME     = "${var.quay_username}"
    QUAY_PASSWORD     = "${var.quay_password}"
  }
}

resource "random_string" "default" {
  length    = 6
  special   = false
}
