variable "region" { type = "string" }
variable "amis" { type = "map" }
variable "instance_types" { type = "map" }
variable "username" { type = "string" }

variable "num_managers" {}
variable "num_workers" {}

variable "vpc_id" { type = "string" }