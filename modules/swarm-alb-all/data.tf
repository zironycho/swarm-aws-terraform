data "aws_subnet_ids" "default" {
  vpc_id    = "${var.vpc_id}"
}

data "aws_lb" "swarm" {
  name      = "${var.lb_name}"
}

data "aws_security_groups" "http_all" {
  filter {
    name   = "group-name"
    values = ["http_all"]
  }
  filter {
    name   = "vpc-id"
    values = ["${var.vpc_id}"]
  }
}

data "aws_instances" "swarm" {
  filter {
    name    = "instance.group-name"
    values  = ["${var.bastion_group_name}"]
  }

  filter {
    name    = "network-interface.vpc-id"
    values  = ["${var.vpc_id}"]
  }
}

data "aws_acm_certificate" "default" {
  count     = "${var.ssl_enabled ? 1 : 0}"
  domain    = "${var.acm_domain}"
  types     = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "default" {
  count     = "${var.route53_enabled ? 1 : 0}"
  name      = "${var.route53_zone_name}"
}
