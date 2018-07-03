#!/bin/bash
docker network create -d overlay proxy

docker service create -d --name traefik \
  --constraint=node.role==manager \
  -p 8080:80 -p 8081:8080 \
  --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock \
  --network proxy \
  traefik \
  --docker \
  --docker.swarmmode \
  --docker.domain=$HOST \
  --docker.watch \
  --api

docker service create -d --name viz \
  --constraint=node.role==manager \
  --label "traefik.backend=viz" \
  --label "traefik.port=8080" \
  --label "traefik.frontend.rule=Host:$HOST;PathPrefixStrip:/viz" \
  --network proxy \
  --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  dockersamples/visualizer

docker service create -d --name portainer \
  --constraint 'node.role == manager' \
  --label "traefik.backend=portainer" \
  --label "traefik.port=9000" \
  --label "traefik.frontend.rule=Host:$HOST;PathPrefixStrip:/portainer" \
  --network proxy \
  --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  portainer/portainer

git clone https://github.com/zironycho/swarmprom.git
cd swarmprom
docker stack deploy -c docker-compose-traefik.yml mon
