#!/usr/bin/env bash
# display logs for a given service
# usage:
# last 200 lines for datanimist
# - xdo dev_grh logs datanimist 200

_app=$1
shift
_tail=${1:-100}

xdo $STG docker-compose logs -t --tail $_tail $_app
# docker-compose logs does NOT support other `docker log` options,
# like --until or --since, unfortunately
#xdo $STG docker-compose logs $* $_app
