data "aws_route53_zone" "default" {
  count               = "${var.route53_enabled ? 1 : 0}"
  name                = "${var.route53_zone_name}"
}

resource "aws_route53_record" "default" {
  count               = "${var.route53_enabled ? 1 : 0}"
  zone_id             = "${data.aws_route53_zone.default.zone_id}"
  name                = "${var.route53_record_name}"
  type                = "A"
  alias {
    name              = "${aws_lb.frontend.dns_name}"
    zone_id           = "${aws_lb.frontend.zone_id}"
    evaluate_target_health = false
  }
}