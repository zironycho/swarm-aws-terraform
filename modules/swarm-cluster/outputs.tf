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
    "http://${aws_lb.frontend.dns_name}/viz/",
    "http://${aws_lb.frontend.dns_name}/grafana",
    "http://${aws_lb.frontend.dns_name}/prom",
    "http://${aws_lb.frontend.dns_name}/portainer/",
  ]
}

output "nodes" {
  value = [
    "${aws_instance.swarm_master.private_ip}",
    "${aws_instance.swarm_manager.*.private_ip}",
    "${aws_instance.swarm_worker.*.private_ip}",
  ]
}

output "bastion" {
  value = "${module.bastion.public_ip}"
}
