provider "aws" {
  region = "ap-southeast-1"
}

# ====================================================

module "alb_80" {

  source = "github.com/zironycho/swarm-aws-terraform//modules/swarm-alb-all"
  vpc_id              = "{{ input swarm vpc id }}"
  lb_name             = "{{ input swarm frontend lb name }}"
  bastion_group_name  = "bastion_group"
  name                = "new-alb"
  swarm_port          = 80

  #ssl_enabled         = true
  #acm_domain          = "*.example.com"

  #route53_enabled     = true
  #route53_zone_name   = "example.com."
  #route53_record_name = "new-alb.example.com"
}

# ====================================================
output "addrs" {
  value = [
    "${module.alb_80.dns_name}" 
  ]
}

