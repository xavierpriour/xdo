#!/usr/bin/env bash

# This script should be run right after the actual machine has been installed.
# It will set it up to receive app, services and infrastructure.
#
# It is non destructive and can also be called on an existing host, to add it to the client docker-machine lists.
#
# Ex: ./xdo prod_client1 create

ensure SSH_USER SSH_HOST SSH_KEY DOM_NAME

exists=`docker-machine ls | grep -e "$DOM_NAME"`

if [ -z "$exists" ] || [ "$1" = "--force" ]; then
  echo "-- create $DOM_NAME"
  # 1. if ssh key does not exist, create it
  if [ ! -e $SSH_KEY ]; then
    folder=$(dirname "$SSH_KEY")
    file=$(basename "$SSH_KEY")
    echo "key $file does not exist, creating it in folder $folder"
    # 1. create folder
    mkdir -p $folder
    # 2. generate key
    ssh-keygen -t rsa -b 4096 -o -a 100 -C "$DOM_NAME" -f $SSH_KEY
  fi

  # 2. copy ssh key file - they should be called <pki> and <pki>.pub and be stored in the same (safe) local folder
  IS_COREOS=`sshExec 'cat /etc/os-release' | grep CoreOS`
  if [ "$IS_COREOS" ]; then
    cat $SSH_KEY.pub | sshExec 'cat | update-ssh-keys -a docker-machine'
  else
    cat $SSH_KEY.pub | sshExec 'cat > .ssh/authorized_keys'
  fi

  # there is a bug in docker-machine that uses older 'docker daemon' command instead of the
  # correct 'dockerd' in the service defintion


  # engine-storage-driver is mandatory, otherwise crashes on kimsufi
  docker-machine -D create \
    --driver generic \
    --generic-ip-address $SSH_HOST\
    --generic-ssh-user $SSH_USER \
    --generic-ssh-key $SSH_KEY \
    --generic-ssh-port ${SSH_PORT:-22} \
    --engine-storage-driver devicemapper \
    $DOM_NAME

  # setup docker to restart on reboot
  sshExec "sudo systemctl enable docker"
  # setup iptables to load rules on reboot
  sshExec "sudo systemctl enable iptables-restore"

  echo "----"
  echo "If there are errors in the above lines, see notes inside create.sh for how to fix"
else
  echo "-- existing $DOM_NAME"
fi

# NOTE
# There is currently a bug on docker-machine.
# The service file it creates in /etc/systemd/system/docker.service.d/10-machine.conf has an incorrect command
# We need to remove it, then restart.
# At this point the service file at /lib/systemd/system/docker.service takes precedence (and it has the right command)
#
# Then we can:
# - finish install: xdo $stg create --force
# - regen cert if needed: docker-machine regenerate-certs $stg-all-1

# setup docker to restart on reboot
#sshExec "sudo systemctl enable docker"
# setup iptables to load rules on reboot
#sudo systemctl enable iptables-restore
