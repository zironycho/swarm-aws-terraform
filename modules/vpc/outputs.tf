output "id" {
  value = "${aws_vpc.main.id}"
}

output "az_subnet_ids" {
  value = ["${aws_subnet.az_subnet.*.id}"]
}
