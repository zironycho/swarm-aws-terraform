provider "aws" {
  region = "ap-southeast-1"
}

module "swarm" {
  source = "../modules/swarm-cluster"

  debug = true
  
  num_managers = 2
  num_workers = 4
  instance_types {
    manager = "t2.micro"
    worker = "t2.micro"
  }
}
