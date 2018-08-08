variable "vpc_id" { 
  type = "string" 
}

variable "lb_name" {
  type = "string"
}

variable "bastion_group_name" {
  type = "string"
}

variable "name" {
  type = "string"
}

variable "swarm_port" {
  type = "string"
}

variable "ssl_enabled" {
  default = false
}

variable "acm_domain" {
  default = ""
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
