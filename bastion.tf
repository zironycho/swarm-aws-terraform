resource "aws_instance" "bastion" {
  ami             = "${var.amis["bastion"]}"
  instance_type   = "t2.nano"
  key_name        = "${aws_key_pair.generated_key.key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.bastion.id}",
    "${aws_security_group.swarm.id}",
  ]

  subnet_id = "${aws_subnet.az_subnet.*.id[0]}"

  tags { 
    Name = "swarm by tf" 
  }
}

resource "aws_eip" "bastion" {
  instance = "${aws_instance.bastion.id}"
  vpc = true
}
