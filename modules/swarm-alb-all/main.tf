resource "aws_lb_listener" "default" {
  load_balancer_arn   = "${aws_lb.default.arn}"
  port                = "80"
  protocol            = "HTTP"
  default_action {
    target_group_arn  = "${aws_lb_target_group.default.arn}"
    type              = "forward"
  }
}

resource "aws_lb_listener" "ssl" {
  count               = "${var.ssl_enabled ? 1 : 0}"
  load_balancer_arn   = "${aws_lb.default.arn}"
  port                = "443"
  protocol            = "HTTPS"
  ssl_policy          = "ELBSecurityPolicy-2016-08"
  certificate_arn     = "${data.aws_acm_certificate.default.arn}"
  default_action {
    target_group_arn  = "${aws_lb_target_group.default.arn}"
    type              = "forward"
  }
}

resource "aws_lb" "default" {
  name                = "${var.name}"
  internal            = false
  load_balancer_type  = "application"
  enable_deletion_protection = false
  subnets             = ["${data.aws_subnet_ids.default.ids}"]
  security_groups     = [
    "${data.aws_lb.swarm.security_groups}", 
    "${data.aws_security_groups.http_all.ids}"
  ]

  tags {
    Name = "swarm by tf"
    Swarm = "yes"
    Terraform = "yes"
    Added = "yes"
  }
}

# ================================================================
# target group
# ================================================================
resource "aws_lb_target_group" "default" {
  name                = "${var.name}"
  vpc_id              = "${var.vpc_id}"
  port                = "${var.swarm_port}"
  protocol            = "HTTP"

  tags {
    Name = "swarm by tf"
    Swarm = "yes"
    Terraform = "yes"
    Added = "yes"
  }
}

resource "aws_lb_target_group_attachment" "default" {
  target_group_arn    = "${aws_lb_target_group.default.arn}"
  count               = "${length(data.aws_instances.swarm.ids)}"
  target_id           = "${data.aws_instances.swarm.ids[count.index]}"
}

# ================================================================
# route 53
# ================================================================
resource "aws_route53_record" "default" {
  count               = "${var.route53_enabled ? 1 : 0}"
  zone_id             = "${data.aws_route53_zone.default.zone_id}"
  name                = "${var.route53_record_name}"
  type                = "A"
  alias {
    name              = "${aws_lb.default.dns_name}"
    zone_id           = "${aws_lb.default.zone_id}"
    evaluate_target_health = false
  }
}