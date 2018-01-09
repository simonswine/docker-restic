#!/bin/sh

head -n 2 /etc/resolv.conf > /etc/resolv.conf.right
cat /etc/resolv.conf.right > /etc/resolv.conf

mkdir -p "${HOME}/.ssh"

echo "${SSH_ID_RSA}" > "${HOME}/.ssh/id_rsa"
chmod 0400 "${HOME}/.ssh/id_rsa"

echo "${SSH_KNOWN_HOSTS}" > "${HOME}/.ssh/known_hosts"
chmod 0600 "${HOME}/.ssh/known_hosts"

exec /bin/restic "$@"
