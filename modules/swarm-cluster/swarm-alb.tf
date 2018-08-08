resource "aws_lb_listener" "frontend" {
  load_balancer_arn = "${aws_lb.frontend.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.frontend.arn}"
    type             = "forward"
  }
}

resource "aws_lb" "frontend" {
  name               = "${var.name_frontend}-${random_string.default.result}"
  internal           = false
  load_balancer_type = "application"
  enable_deletion_protection = false
  subnets            = ["${module.vpc.az_subnet_ids}"]
  security_groups    = [
    "${aws_security_group.swarm.id}",
    "${aws_security_group.http.id}",
  ]

  tags {
    Name = "swarm by tf"
    Swarm = "yes"
    Terraform = "yes"
  }
}

# ================================================================
# target group
# ================================================================
resource "aws_lb_target_group" "frontend" {
  name              = "${var.name_frontend}-${random_string.default.result}"
  port              = 8080
  protocol          = "HTTP"
  vpc_id            = "${module.vpc.id}"

  tags {
    Name = "swarm by tf"
    Swarm = "yes"
    Terraform = "yes"
  }
}

resource "aws_lb_target_group_attachment" "master" {
  target_group_arn  = "${aws_lb_target_group.frontend.arn}"
  target_id         = "${aws_instance.swarm_master.id}"
}

resource "aws_lb_target_group_attachment" "manager" {
  count = "${var.num_managers}"
  target_group_arn  = "${aws_lb_target_group.frontend.arn}"
  target_id         = "${element(aws_instance.swarm_manager.*.id, count.index)}"
}

resource "aws_lb_target_group_attachment" "worker" {
  count = "${var.num_workers}"
  target_group_arn  = "${aws_lb_target_group.frontend.arn}"
  target_id         = "${element(aws_instance.swarm_worker.*.id, count.index)}"
}
