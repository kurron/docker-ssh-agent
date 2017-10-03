#!/bin/bash

# Pulls the private SSH key from Ansible Vault.  All variables are expected
# to be available in the environment.

echo "VAULT_ADDR is ${VAULT_ADDR}"

# log into Vault
LOGIN="vault write auth/approle/login role_id=${ROLE_ID} secret_id=${SECRET_ID}"
echo ${LOGIN}
${LOGIN}

# generate a temporary access token
GRAB_TOKEN="vault write -field=token auth/approle/login role_id=${ROLE_ID} secret_id=${SECRET_ID}"
echo ${GRAB_TOKEN}
export VAULT_TOKEN=$(${GRAB_TOKEN})
#echo ${VAULT_TOKEN}

# read the SSH key
PRIVATE_SSH_KEY=$(vault read ${VAULT_PATH})
#echo ${PRIVATE_SSH_KEY}

# add the key to the SSH agent
ADD_KEY="echo ${PRIVATE_SSH_KEY} | ssh-add "
echo ${ADD_KEY}
${ADD_KEY}

# prove that the key was installed
SHOW_KEY="ssh-add -L"
${SHOW_KEY}
