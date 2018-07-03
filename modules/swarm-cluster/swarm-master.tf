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
  }

  user_data     = <<-EOF
    #!/bin/bash
    docker swarm init
    docker swarm join-token worker --quiet > /worker.txt
    docker swarm join-token manager --quiet > /manager.txt
    EOF
}
