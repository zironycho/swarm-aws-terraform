resource "aws_security_group" "swarm" {
  name        = "swarm"
  description = "tf swarm"
  vpc_id            = "${aws_vpc.swarm.id}"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    self            = true
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    cidr_blocks     = ["0.0.0.0/0"]
    ipv6_cidr_blocks= ["::/0"]
  }

  tags { Name = "swarm by tf" }
}
