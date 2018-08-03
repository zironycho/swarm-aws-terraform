data "aws_availability_zones" "az" {}

locals {
  az_count = "${length(data.aws_availability_zones.az.names)}"
}

resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"
}

resource "aws_subnet" "az_subnet" {
  count      = "${local.az_count}"
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.vpc_subnet_cidrs[count.index]}"
  availability_zone = "${data.aws_availability_zones.az.names[count.index]}"
  map_public_ip_on_launch = true

  tags {
    Name = "swarm by tf"
    Swarm = "yes"
    Terraform = "yes"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "swarm by tf"
    Swarm = "yes"
    Terraform = "yes"
  }
}

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "swarm by tf"
    Swarm = "yes"
    Terraform = "yes"
  }
}

resource "aws_route_table_association" "a" {
  count          = "${local.az_count}"
  subnet_id      = "${aws_subnet.az_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.r.id}"
}
