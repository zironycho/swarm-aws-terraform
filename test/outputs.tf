output "private_key" {
  value = "${module.swarm.private_key}"
}

output "master" {
  value = "${module.swarm.master}"
}

output "master_ip" {
  value = "${module.swarm.master_ip}"
}

output "elb_address" {
  value = "${module.swarm.elb_address}"
}

output "services" {
  value = "${module.swarm.services}"
}

output "nodes" {
  value = "${module.swarm.nodes}"
}

output "bastion" {
  value = "${module.swarm.bastion}"
}
