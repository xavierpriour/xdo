#!/usr/bin/env bash
#execute docker-compose with the file of the specified stage
setDockerComposeFile
dockerCompose -f $docker_compose_file $*
