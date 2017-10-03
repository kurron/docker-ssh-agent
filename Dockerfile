FROM ubuntu:16.04

MAINTAINER Ron Kurr <kurr@kurron.org>

# spit out the Vault version, by default
CMD ["vault", "--version"]

# ---- watch your layers and put likely mutating operations here -----
COPY populate-ssh-agent.sh /tmp/

ADD https://releases.hashicorp.com/vault/0.8.3/vault_0.8.3_linux_amd64.zip /tmp/vault.zip
RUN apt-get update --yes && \
    apt-get install --yes unzip openssh-client && \
    apt-get purge --yes && \
    unzip /tmp/vault.zip -d /usr/local/bin && \
    chmod a+w /usr/local/bin/vault
