#!/usr/bin/env bash
# call from root of the project!

echo "-- starting $* on $STG"

if [ ! "$NO_DAEMON" ]; then
  daemon_cmd=-d
fi

setDockerComposeFile

dockerCompose -f $docker_compose_file up $daemon_cmd $*
