resource "aws_instance" "swarm_master" {
  ami           = "${module.ami.id}"
  instance_type = "${var.instance_types["manager"]}"
  key_name      = "${aws_key_pair.generated_key.key_name}"

  vpc_security_group_ids = [
    "${module.bastion.security_group_id}",
    "${aws_security_group.swarm.id}",
  ]

  subnet_id = "${module.vpc.az_subnet_ids[0]}"

  tags {
    Name = "swarm by tf - master"
    Swarm = "yes"
    Terraform = "yes"
  }

  user_data     = <<-EOF
    #!/bin/bash
    docker swarm init
    docker swarm join-token worker --quiet > /worker.txt
    docker swarm join-token manager --quiet > /manager.txt
    EOF

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
