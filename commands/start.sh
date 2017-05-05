#!/usr/bin/env bash
# call from root of the project!

echo "-- starting $* on $STG"
docker-compose -f stages/$STG/docker-compose.yml up -d $*

#if first run, launch meteor then wait for initial load do complete before launching nginx+vpn
# docker-compose up meteor