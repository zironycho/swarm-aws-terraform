resource "aws_security_group" "bastion" {
  name = "bastion"
  description = "Allow SSH traffic from the internet"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    ipv6_cidr_blocks= ["::/0"]
  }

  egress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${var.internal_security_group_id}"]
  }

  tags { Name = "swarm by tf" }
}

resource "aws_security_group" "bastion_group" {
  name = "bastion_group"
  description = "Grants access to SSH from bastion server"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.bastion.id}"]
  }
}
