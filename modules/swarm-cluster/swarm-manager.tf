resource "aws_instance" "swarm_manager" {
  count         = "${var.num_managers}"
  ami           = "${module.ami.id}"
  instance_type = "${var.instance_types["manager"]}"
  depends_on    = ["aws_instance.swarm_master"]
  key_name      = "${aws_key_pair.generated_key.key_name}"

  vpc_security_group_ids = [
    "${module.bastion.security_group_id}",
    "${aws_security_group.swarm.id}",
  ]

  subnet_id = "${module.vpc.az_subnet_ids[(count.index + 1) % local.az_count]}"

  tags {
    Name = "swarm by tf - manager"
    Swarm = "yes"
    Terraform = "yes"
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
      "scp -i ~/key.pem ${var.username}@${aws_instance.swarm_master.private_ip}:/manager.txt ./",
      "docker swarm join --token $$(cat manager.txt) ${aws_instance.swarm_master.private_ip}:2377"
    ]
  }

  provisioner "file" {
    content = "${data.template_file.docker_init.rendered}"
    destination = "~/docker-init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/docker-init.sh",
      "~/docker-init.sh",
    ]
  }

  # set node label
  provisioner "remote-exec" {
    inline = [
      "docker node update --label-add az=${self.availability_zone} ${self.private_dns}",
    ]
  }
}
