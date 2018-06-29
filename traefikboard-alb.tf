
resource "aws_lb" "traefik_dashboard" {
  name               = "traefik-dashboard"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [
    "${aws_security_group.swarm.id}",
    "${aws_security_group.http.id}",
  ]
  subnets            = ["${aws_subnet.az_subnet.*.id}"]

  enable_deletion_protection = false

  tags {
    Name = "swarm by tf"
    Environment = "production"
  }
}

resource "aws_lb_listener" "treafik_dashboard" {
  load_balancer_arn = "${aws_lb.traefik_dashboard.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.traefik_dashboard.arn}"
    type             = "forward"
  }
}
