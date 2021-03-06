#!/usr/bin/env bash

# Preps a docker machine for deployment,
# creating local folders and copying config files that will then be mounted.
# Beware: calling it on an existing machine will not erase user data BUT reset its config.
#
# The provisioning script it delegates to should properly handle the various setup possibilities
# (local live dev vs production).
#
# With an argument, will only provision/reset the specified service/app

#ensure DOM_NAME

# default to provisioning EVERYTHING
initial_list=$*
: ${initial_list:='+applications +services'}

setTargetList $initial_list
onlyAppsOrServices $target_list

for tgt in $target_list
do
  setAppTag $tgt
  if [ -e "./applications/$app/provision.sh" ]; then
    echo "-- provisioning app $app"
    cd ./applications/$app
    ./provision.sh
    cd ../..
  elif [ -e "./services/$app/provision.sh" ]; then
    echo "-- provisioning service $app"
    ./services/$app/provision.sh
  elif [ -e "./infra/$app/provision.sh" ]; then
    echo "-- provisioning infra $app"
    ./infra/$app/provision.sh
  else
    echo "-- no provisioning needed for $app, skipped"
  fi
done
