#!/usr/bin/env bash

# Executes args as commands on $STG.
# Runs locally if no SSH user/host specified.
#
# Env variables to set:
# - SSH_USER
# - SSH_HOST
# - SSH_KEY: path to SSH private key file to use. Optional, default be standard ssh (try all private keys)
# - SSH_PORT: SSH server port. Optional, defaults is standard ssh (22)

sshExec $*
