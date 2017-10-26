#!/usr/bin/env bash
# call from root of the project!

echo "-- stopping $* on $STG"

setDockerComposeFile

docker-compose -f $docker_compose_file stop $*

#if first run, launch meteor then wait for initial load do complete before launching nginx+vpn
# docker-compose up meteor
