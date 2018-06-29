data "aws_availability_zones" "az" {}

resource "aws_vpc" "swarm" {
  cidr_block = "${var.vpc_cidr}"
}

resource "aws_subnet" "az_subnet" {
  count      = 3
  vpc_id     = "${aws_vpc.swarm.id}"
  cidr_block = "${var.vpc_subnet_cidrs[count.index]}"
  availability_zone = "${data.aws_availability_zones.az.names[count.index]}"
  map_public_ip_on_launch = true

  tags {
    Name = "tf_subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.swarm.id}"

  tags {
    Name = "tf"
  }
}

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.swarm.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "tf"
  }
}

resource "aws_route_table_association" "a" {
  count          = 3
  subnet_id      = "${aws_subnet.az_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.r.id}"
}
