
key:
	@rm -f key.pem
	@terraform output private_key > key.pem
	@chmod 400 key.pem

ssh:
	@ssh -i key.pem -Ao ProxyCommand="ssh -i key.pem -W %h:%p core@$(shell terraform output bastion)" core@$(shell terraform output master_ip)

addr:
	@terraform output elb_address

nodes:
	@terraform output nodes

ssh-bastion:
	@ssh -i key.pem core@$(shell terraform output bastion)

ssh-node:
	@ssh -i key.pem -Ao ProxyCommand="ssh -i key.pem -W %h:%p core@$(shell terraform output bastion)"  core@${addr}

services:
	@terraform output services