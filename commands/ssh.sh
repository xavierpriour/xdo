#!/usr/bin/env bash

# Executes args as commands on $STG

ensure SSH_USER SSH_HOST

sshExec $*
