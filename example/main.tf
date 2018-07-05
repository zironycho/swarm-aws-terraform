provider "aws" {
  region = "ap-southeast-1"
}

module "swarm" {
  source = "github.com/zironycho/swarm-aws-terraform//modules/swarm-cluster"
  
  num_managers = 2
  num_workers = 4
  instance_types {
    manager = "t2.micro"
    worker = "t2.micro"
  }

  # limit IP block to access monitoring services
  # http_cidr_blocks = ["your.public.ip/32",]

  # limit IP v6 block to access monitoring services
  # http_ipv6_cidr_blocks = []

  # add frontend monitoring url record in route53
  # route53_enabled     = true
  # route53_zone_name   = "example.com."
  # route53_record_name = "mon.example.com"

  # enable rexray s3fs, ebs
  # aws_accesskey       = "aws access key"
  # aws_secretkey       = "aws private key"

  # enable quay.io private repository
  # quay_username       = "user name or bot name"
  # quay_password       = "user password or bot password"
}
