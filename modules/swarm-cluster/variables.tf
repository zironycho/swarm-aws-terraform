variable "instance_types" { type = "map" }

variable "num_managers" {}
variable "num_workers" {}

variable "vpc_cidr" { 
  default = "10.0.0.0/16"
}

variable "vpc_subnet_cidrs" { 
  default = [
    "10.0.0.0/20",
    "10.0.16.0/20",
    "10.0.32.0/20",
  ]
}

variable "username" {
  default = "core"
}

variable "http_cidr_blocks" {
  default = [
    "0.0.0.0/0"
  ]
}

variable "http_ipv6_cidr_blocks" {
  default = [
    "::/0"
  ]
}

variable "frontend_host" {
  default = ""
}