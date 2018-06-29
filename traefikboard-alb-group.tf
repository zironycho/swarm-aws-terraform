resource "aws_lb_target_group" "traefik_dashboard" {
  name     = "traefik-dashboard"
  port     = 8081
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_lb_target_group_attachment" "traefik_dashboard" {
  target_group_arn = "${aws_lb_target_group.traefik_dashboard.arn}"
  target_id        = "${aws_instance.swarm_master.id}"
}
