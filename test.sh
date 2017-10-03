#!/bin/bash

# Any arguments provided to this script will be the command run inside the container.
# This to try:
#   * ansible --version
#   * ansible all --inventory='localhost,' --connection=local -m ping

VAULT_ADDRESS=${1:-http://192.168.254.90:8200}
ROLE_ID=${2:-ab30c420-3f48-60e3-b45e-07a672aa4860}
SECRET_ID=${3:-0fb79713-0c1b-edd2-6d60-b6714da074d2}
VAULT_PATH=${4:-secret/build/ssh/slurpe}

function runContainer() {
  local SSH_GROUP_ID=$(cut -d: -f3 < <(getent group ssh))
  local USER_ID=$(id -u $(whoami))
  local GROUP_ID=$(id -g $(whoami))
  local WORK_AREA=/work-area
  local HOME_DIR=$(cut -d: -f6 < <(getent passwd ${USER_ID}))

  local CMD="docker run --net host \
                  --hostname inside-docker \
                  --env HOME=${HOME_DIR} \
                  --env SSH_AUTH_SOCK=${SSH_AUTH_SOCK} \
                  --env VAULT_ADDR=${VAULT_ADDRESS} \
                  --env ROLE_ID=${ROLE_ID} \
                  --env SECRET_ID=${SECRET_ID} \
                  --env VAULT_PATH=${VAULT_PATH} \
                  --interactive \
                  --name ssh-agent-test \
                  --rm \
                  --tty \
                  --user=${USER_ID}:${GROUP_ID} \
                  --volume ${SSH_AUTH_SOCK}:${SSH_AUTH_SOCK} \
                  --volume ${HOME_DIR}:${HOME_DIR} \
                  --volume /etc/passwd:/etc/passwd \
                  --volume /etc/group:/etc/group \
                  --workdir /tmp \
                  dockersshagent_deployer:latest /tmp/populate-ssh-agent.sh"
  echo $CMD
  $CMD
}

runContainer
