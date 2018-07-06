resource "aws_instance" "bastion" {
  instance_type   = "t2.nano"
  ami             = "${var.ami}"
  key_name        = "${var.aws_key_name}"
  subnet_id       = "${var.subnet_id}"

  vpc_security_group_ids = [
    "${aws_security_group.bastion.id}",
    "${var.internal_security_group_id}",
  ]


  tags {
    Name = "swarm by tf - bastion"
    Swarm = "yes"
    Terraform = "yes"
  }
}

resource "aws_eip" "bastion" {
  instance = "${aws_instance.bastion.id}"
  vpc = true
}
