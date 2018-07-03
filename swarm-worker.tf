resource "aws_instance" "swarm_worker" {
  count         = "${var.num_workers}"
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "${var.instance_types["worker"]}"
  depends_on    = ["aws_instance.swarm_master"]
  key_name      = "${aws_key_pair.generated_key.key_name}"

  vpc_security_group_ids = [
    "${module.bastion.security_group_id}",
    "${aws_security_group.swarm.id}",
  ]

  subnet_id = "${module.vpc.az_subnet_ids[0]}"

  tags { 
    Name = "swarm by tf - worker" 
  }

  connection {
    type        = "ssh"
    host        = "${self.private_ip}"
    user        = "${var.username}"
    private_key = "${tls_private_key.tf-key.private_key_pem}"

    bastion_host        = "${module.bastion.public_ip}"
    bastion_user        = "${var.username}"
    bastion_private_key = "${tls_private_key.tf-key.private_key_pem}"
  }


  provisioner "file" {
    content     = "${tls_private_key.tf-key.private_key_pem}"
    destination = "~/key.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 ~/key.pem",
      "ssh-keyscan ${aws_instance.swarm_master.private_ip} >> ~/.ssh/known_hosts",
      "scp -i ~/key.pem ${var.username}@${aws_instance.swarm_master.private_ip}:/worker.txt ./",
      "docker swarm join --token $$(cat worker.txt) ${aws_instance.swarm_master.private_ip}:2377"
    ]
  }
}
