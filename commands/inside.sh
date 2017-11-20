#!/usr/bin/env bash

# runs the arg command inside the specified container
# - xdo dev inside datanimist meteor --version
# - xdo dev inside batchete npm update

service=$1
shift

# todo ensure service exists
#if [ -z "$stg_tgt" ] || [ ! -d "./stages/$stg_tgt" ]; then
#  echo "deploy needs argument set to target stage (like 'pre1'), got '$stg_tgt'"
#  exit 1
#fi

# we may have different stacks running the same services,
# if we do we actually want to use the one that is currently up
running=`docker ps | grep _${service}_ | sed -E "s/([[:alnum:]]+_${service}_[[:digit:]]+).*/\1/"`

if [ "$running" ]; then
  docker exec $running $*
else
  xdo $STG docker-compose run --rm $service $*
fi
