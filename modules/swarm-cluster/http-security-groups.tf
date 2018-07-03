resource "aws_security_group" "http" {
  name              = "http"
  description       = "tf elb open ports"
  vpc_id            = "${module.vpc.id}"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = "${var.http_cidr_blocks}"
    ipv6_cidr_blocks= "${var.http_ipv6_cidr_blocks}"
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = "${var.http_cidr_blocks}"
    ipv6_cidr_blocks= "${var.http_ipv6_cidr_blocks}"
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
