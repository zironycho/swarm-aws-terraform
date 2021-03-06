resource "aws_lb_listener" "treafik_dashboard" {
  load_balancer_arn = "${aws_lb.traefik_dashboard.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.traefik_dashboard.arn}"
    type             = "forward"
  }
}

resource "aws_lb" "traefik_dashboard" {
  name               = "${var.name_traefik_dashboard}-${random_string.default.result}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [
    "${aws_security_group.swarm.id}",
    "${aws_security_group.http.id}",
  ]
  subnets            = ["${module.vpc.az_subnet_ids}"]

  enable_deletion_protection = false

  tags {
    Name = "swarm by tf"
    Swarm = "yes"
    Terraform = "yes"
  }
}

# ================================================================
# target group
# ================================================================
resource "aws_lb_target_group" "traefik_dashboard" {
  name              = "${var.name_traefik_dashboard}-${random_string.default.result}"
  port              = 8081
  protocol          = "HTTP"
  vpc_id            = "${module.vpc.id}"

  tags {
    Name = "swarm by tf"
    Swarm = "yes"
    Terraform = "yes"
  }
}

resource "aws_lb_target_group_attachment" "traefik_dashboard" {
  target_group_arn  = "${aws_lb_target_group.traefik_dashboard.arn}"
  target_id         = "${aws_instance.swarm_master.id}"
}
