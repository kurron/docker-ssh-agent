#!/bin/bash

set -x

# Pulls the private SSH key from Ansible Vault.  All variables are expected
# to be available in the environment.

echo "VAULT_ADDR is ${VAULT_ADDR}"

# generate a temporary access token
export VAULT_TOKEN=$(vault write -field=token auth/approle/login role_id=${ROLE_ID} secret_id=${SECRET_ID})

# read the value from Vault, storing it in /tmp so ssh-add can read it
KEY_FILE=/tmp/private-key
vault read -field=value ${VAULT_PATH} > ${KEY_FILE}
chmod 0400 ${KEY_FILE}

# add the key to the SSH agent for 5 minutes
ssh-add -t 300 ${KEY_FILE}

# prove that the key was installed
ssh-add -L
