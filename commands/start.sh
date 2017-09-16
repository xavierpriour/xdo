#!/usr/bin/env bash
# call from root of the project!

echo "-- starting $* on $STG"

if [ ! "$NO_DAEMON" ]; then
  daemon_cmd=-d
fi

setDockerComposeFile

docker-compose -f $docker_compose_file up $daemon_cmd $*

#if first run, launch meteor then wait for initial load do complete before launching nginx+vpn
# docker-compose up meteor