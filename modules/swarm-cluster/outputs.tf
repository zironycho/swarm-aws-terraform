output "private_key" {
  value = "${tls_private_key.tf-key.private_key_pem}"
}

output "master" {
  value = "${aws_instance.swarm_master.public_ip}"
}

output "master_ip" {
  value = "${aws_instance.swarm_master.private_ip}"
}


output "elb_address" {
  value = [
    "${aws_lb.frontend.dns_name}",
    "${aws_lb.traefik_dashboard.dns_name}",
  ]
}

output "services" {
  value = [
    "http://${aws_lb.traefik_dashboard.dns_name}",
    "http://${local.frontend_host}/viz/",
    "http://${local.frontend_host}/grafana",
    "http://${local.frontend_host}/prom",
    "http://${local.frontend_host}/portainer/",
  ]
}

output "nodes" {
  value = [
    "${aws_instance.swarm_master.private_ip}",
    "${aws_instance.swarm_manager.*.private_ip}",
    "${aws_instance.swarm_worker.*.private_ip}",
  ]
}

output "node_ids" {
  value = [
    "${aws_instance.swarm_master.id}",
    "${aws_instance.swarm_manager.*.id}",
    "${aws_instance.swarm_worker.*.id}",
  ]
}

output "bastion" {
  value = "${module.bastion.public_ip}"
}

output "http_security_group_ids" {
  value = [
    "${aws_security_group.swarm.id}",
    "${aws_security_group.http.id}",
  ]
}

output "subnet_ids" {
  value = "${module.vpc.az_subnet_ids}"
}