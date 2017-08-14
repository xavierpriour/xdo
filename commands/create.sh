#!/usr/bin/env bash

# This script should be run right after the actual machine has been installed.
# It will set it up to receive app, services and infrastructure.
#
# It is non destructive and can also be called on an existing host, to add it to the client docker-machine lists.
#
# Ex: ./xdo prod_client1 create

ensure SSH_USER SSH_HOST SSH_KEY DOM_NAME

exists=`docker-machine ls | grep -e "$DOM_NAME"`

if [ -z "$exists" ]; then
  echo "-- create $DOM_NAME"
  # copy the ssh key file (will need root password)
  # they should be called <pki> and <pki>.pub and be stored in the same (safe) local folder
  cat $SSH_KEY.pub | ssh $SSH_USER@$SSH_HOST 'cat > .ssh/authorized_keys'

  # engine-storage-driver is mandatory, otherwise crashes on kimsufi
  docker-machine -D create \
    --driver generic \
    --generic-ip-address $SSH_HOST\
    --generic-ssh-user $SSH_USER \
    --generic-ssh-key $SSH_KEY \
    --generic-ssh-port ${SSH_PORT:-22} \
    --engine-storage-driver devicemapper \
    $DOM_NAME
else
  echo "-- existing $DOM_NAME"
fi

# setup docker to restart on reboot
sshExec "sudo systemctl enable docker"
# setup iptables to load rules on reboot
sudo systemctl enable iptables-restore
