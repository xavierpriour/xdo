#!/usr/bin/env bash

# Clean up build artefacts
#
# Currently it removes:
# - docker container that are no longer running
# - docker images that are dangling
#
# STG is the machine on which to perform the cleaning

echo "-- remove exited containers"
sshExec 'if [ -z "$(docker ps -a -q -f status=exited)" ]; then echo "(none)"; else docker rm -v $(docker ps -a -q -f status=exited); fi'

echo "-- remove dangling images"
sshExec 'if [ -z "$(docker images --filter "dangling=true" -q --no-trunc)" ]; then echo "(none)"; else docker rmi $(docker images --filter "dangling=true" -q --no-trunc); fi'
