#!/usr/bin/env bash
#execute docker-compose with the file of the specified stage
setDockerComposeFile
docker-compose -f $docker_compose_file $*