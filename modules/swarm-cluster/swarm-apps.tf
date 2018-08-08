data "template_file" "monitoring" {
  template = "${file("${path.module}/scripts/monitoring.tpl")}"
  
  vars {
    HOST = "${local.frontend_host}"
  }
}

resource "null_resource" "apps" {
  triggers {
    master_id = "${aws_instance.swarm_master.id}"
    frontend_addr = "${aws_lb.frontend.dns_name}"
    dashboard_addr = "${aws_lb.traefik_dashboard.dns_name}"
  }

  connection {
    type        = "ssh"
    host        = "${aws_instance.swarm_master.private_ip}"
    user        = "${var.username}"
    private_key = "${tls_private_key.tf-key.private_key_pem}"

    bastion_host        = "${module.bastion.public_ip}"
    bastion_user        = "${var.username}"
    bastion_private_key = "${tls_private_key.tf-key.private_key_pem}"
  }

  provisioner "file" {
    content     = "${data.template_file.monitoring.rendered}"
    destination = "~/monitoring.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/monitoring.sh",
      "~/monitoring.sh",
    ]
  }
}
