#!/usr/bin/env bash
# call from root of the project!

echo "-- stopping $* on $STG"

setDockerComposeFile

dockerCompose -f $docker_compose_file stop $*
