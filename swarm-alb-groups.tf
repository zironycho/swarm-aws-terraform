resource "aws_lb_target_group" "frontend" {
  name     = "frontend"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_lb_target_group_attachment" "master" {
  target_group_arn = "${aws_lb_target_group.frontend.arn}"
  target_id        = "${aws_instance.swarm_master.id}"
}

resource "aws_lb_target_group_attachment" "manager" {
  count = "${var.num_managers}"
  target_group_arn = "${aws_lb_target_group.frontend.arn}"
  target_id        = "${element(aws_instance.swarm_manager.*.id, count.index)}"
}

resource "aws_lb_target_group_attachment" "worker" {
  count = "${var.num_workers}"
  target_group_arn = "${aws_lb_target_group.frontend.arn}"
  target_id        = "${element(aws_instance.swarm_worker.*.id, count.index)}"
}
