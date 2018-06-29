data "aws_subnet_ids" "already_exists" {
  vpc_id = "${var.vpc_id}"
}
