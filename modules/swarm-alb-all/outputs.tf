output "dns_name" {
  value = "${aws_lb.default.dns_name}"
}

output "instances" {
  value = "${data.aws_instances.swarm.ids}"
}
