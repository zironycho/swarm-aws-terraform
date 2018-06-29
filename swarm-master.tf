resource "aws_instance" "swarm_master" {
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "${var.instance_types["manager"]}"
  key_name      = "${aws_key_pair.generated_key.key_name}"

  security_groups = [
    "${aws_security_group.bastion_group.name}",
    "${aws_security_group.swarm.name}",
  ]

  tags { 
    Name = "swarm by tf - master" 
  }

  user_data     = <<-EOF
    #!/bin/bash
    docker swarm init
    docker swarm join-token worker --quiet > /worker.txt
    docker swarm join-token manager --quiet > /manager.txt
    EOF
}
