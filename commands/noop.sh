#!/usr/bin/env bash

# Just echoes some env variable.
# This is useful to test variables in embedded calls.

setTargetList $*
setDockerComposeFile

echo "
  STG=$STG
  ACTION=$ACTION
  args=$*

  docker-compose=$docker_compose_file
  docker-machine=$DOM_NAME

  target_list=$target_list
"
