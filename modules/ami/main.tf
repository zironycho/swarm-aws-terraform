# reference: https://github.com/coreos/tectonic-installer/blob/master/modules/aws/master-asg/master.tf

module "coreos_latest" {
  source      = "github.com/coreos/tectonic-installer//modules/container_linux"
  release_channel = "${var.container_linux_channel}"
  release_version = "latest"
}

locals {
  ami_owner     = "595879546273"
  arn           = "aws"
  linux_version = "${var.container_linux_version == "latest" ? module.coreos_latest.version : var.container_linux_version}"
}

data "aws_ami" "coreos_ami" {
  filter {
    name   = "name"
    values = ["CoreOS-${var.container_linux_channel}-${local.linux_version}-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-id"
    values = ["${local.ami_owner}"]
  }
}
