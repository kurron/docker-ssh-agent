#!/bin/bash

# use the time as a tag
UNIXTIME=$(date +%s)

# docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]
docker tag dockersshagent_deployer kurron/docker-ssh-agent:latest
docker tag dockersshagent_deployer kurron/docker-ssh-agent:${UNIXTIME}
docker images

# Usage:  docker push [OPTIONS] NAME[:TAG]
docker push kurron/docker-ssh-agent:latest
docker push kurron/docker-ssh-agent:${UNIXTIME}
