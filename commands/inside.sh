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

running=`docker ps | grep ${STG}_${service}_`

if [ "$running" ]; then
  xdo $STG docker-compose exec $service $*
else
  xdo $STG docker-compose run --rm $service $*
fi
