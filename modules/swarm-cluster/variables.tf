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

variable "route53_enabled" {
  default = false
}

variable "route53_zone_name" {
  default = ""
}

variable "route53_record_name" {
  default = ""
}

variable "aws_accesskey" {
  default = ""
}

variable "aws_secretkey" {
  default = ""
}

variable "quay_username" {
  default = ""
}

variable "quay_password" {
  default = ""
}

variable "name_traefik_dashboard" {
  default = "traefik-dashboard"
}

variable "name_frontend" {
  default = "frontend"
}

variable "name_key" {
  default = "tf-key"
}

