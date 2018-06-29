region = "ap-southeast-1"

amis = {
  "ap-southeast-1" = "ami-3cded940"
  "us-west-2" = "ami-662f6d1e"
  "bastion" = "ami-3cded940"
}

instance_types = {
  "manager" = "t2.micro"
  "worker" = "t2.micro"
}

username = "core"

num_managers = 2
num_workers = 4

vpc_cidr = "10.0.0.0/16"
vpc_subnet_cidrs = [
  "10.0.0.0/20",
  "10.0.16.0/20",
  "10.0.32.0/20",
]