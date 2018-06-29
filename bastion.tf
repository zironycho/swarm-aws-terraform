resource "aws_instance" "bastion" {
  ami             = "${var.amis["bastion"]}"
  instance_type   = "t2.nano"
  security_groups = [
    "${aws_security_group.bastion.name}",
  ]
  key_name        = "${aws_key_pair.generated_key.key_name}"

  tags { 
    Name = "swarm by tf" 
  }
}

resource "aws_eip" "bastion" {
  instance = "${aws_instance.bastion.id}"
  vpc = true
}
