#!/usr/bin/env bash

# ensure we have non-empty environment variables for all supplied args, or exit the process.
# Example: ensure DOM_NAME DOM_IP
ensure() {
  for arg in $*
  do
    if [ -z "${!arg}" ]
    then
      echo "error: parameter '$arg' is mandatory but wasn't set"
      exit 1
    fi
  done
}
export -f ensure

onlyAppsOrServices() {
  tgt_list=$*
  # we verify applications/services exist or fail early
  for tgt in $tgt_list
  do
    app=${tgt%%:*}
    # this next line is needed to handle the case when we have only the app, no :tag.
    tag=${tgt##$app}
    tag=${tag##*:}

    if [ ! -d "applications/$app" ] && [ ! -d "services/$app" ] && [ ! -d "infra/$app" ]
    then
      echo "-- $tgt is listed but $app is not a valid app, service, or infra > cancelling"
      exit 1
    fi
  done
}
export -f onlyAppsOrServices

# splits arg into app/tag part, like datanimist:1.0.2 > app=datanimist, tag=1.0.2
# Does NOT use any default value: if none provided, values stay empty
setAppTag() {
  sat_init=$1
  if [ -z "$sat_init" ]; then
    app=""
    tag=""
  else
    app=${sat_init%%:*}
    # this next line is needed to handle the case when we have only the app, no :tag.
    tag=${sat_init##$app}
    tag=${tag##*:}
  fi
}
export -f setAppTag

setDockerComposeFile() {
  inner_stage_compose="./stages/$STG/docker-compose.yml"
  mid_stage_compose="./stages/docker-compose.yml"
  root_stage_compose="./docker-compose.yml"

  if [ -n "$DOCKER_COMPOSE_FILE" ]; then
    docker_compose_file=$DOCKER_COMPOSE_FILE
    if [ ! -e "$docker_compose_file" ]; then
      echo "-- environment declares DOCKER_COMPOSE_FILE=$DOCKER_COMPOSE_FILE but file does not exist, please fix > cancelling"
      exit 1
    fi
  else
    docker_compose_file=$inner_stage_compose
  fi
  if [ ! -e "$docker_compose_file" ]; then
    docker_compose_file=$mid_stage_compose
  fi
  if [ ! -e "$docker_compose_file" ]; then
    docker_compose_file=$root_stage_compose
  fi
  if [ ! -e "$docker_compose_file" ]; then
    echo "-- unable to locate a docker-compose file, please provide one in the $STG dir or at project root > cancelling"
    exit 1
  fi
}
export -f setDockerComposeFile

# finds the exact name of the pod containing service $1
# if pod contains multiple containers, specify which one with pod:container
setK8sPod() {
  k8sPod_input=$1
  k8sPod_inputPod=${k8sPod_input%%:*}
  k8sPod_inputContainer=${k8sPod_input##k8sPod_inputPod}
  k8sPod_inputContainer=${k8sPod_inputContainer##*:}
  k8sPod=`kubectl get po | grep ${k8sPod_inputPod}- | cut -d " " -f1`
  k8sContainer=$k8sPod_inputContainer
}
export -f setK8sPod

# $1 is the list of targets passed to command
# this function will set $target_list to a proper space-separated list of apps or services with an associated tag,
# handling all special cases like (none), +services, or any mix
setTargetList() {
  # if none supplied, list all applications, latest tag
  initial_list=$*
  : ${initial_list:='+applications:latest'}

  for tgt in $initial_list
  do
    setAppTag $tgt

    : ${app:='+applications'}
    : ${tag:=latest}

    tgt="$app:$tag"
    if [ "$app" == '+applications' ]; then
      if [ -d "applications/" ]; then
        tgt=`ls -d applications/*/ | sed -e"s/applications\/\(.*\)\/$/\1:$tag/"`
      else
        tgt=''
      fi
    fi
    if [ "$app" == '+infra' ]; then
      tgt=`ls -d infra/*/ | sed -e"s/infra\/\(.*\)\/$/\1:$tag/"`
    fi
    if [ "$app" == '+services' ]; then
      tgt=`ls -d services/*/ | sed -e"s/services\/\(.*\)\/$/\1:$tag/"`
    fi
    target_list="$target_list$tgt "
  done
  # drop trailing space
  target_list=${target_list%?}
  # flatten newlines
  target_list=`echo $target_list | tr '\n' ' '`
  echo "-- expanded target list to: [$target_list]"
}
export -f setTargetList

# Executes argumens on current docker-machine (using ssh), or locally if no docker-machine defined.
# Example: sshDom docker ps -a
sshExec() {
  if [ -z "$SSH_USER" ] || [ -z "$SSH_HOST" ]
  then
#  echo "args=$*"
    eval $*
  else
    ssh_opts="$SSH_USER@$SSH_HOST"
    if [ -n "$SSH_KEY" ]; then
      ssh_opts="-i $SSH_KEY $ssh_opts"
    fi
    if [ -n "$SSH_PORT" ]; then
      ssh_opts="-p $SSH_PORT $ssh_opts"
    fi
    ssh $ssh_opts $*
#    docker-machine ssh $DOM_NAME $*
  fi
}
export -f sshExec

# Echoes 1st argument preceded by a timestamp
# Example: timestamp "starting deployment on $STG"
timestamp() {
  if [ -n "$XDO_LOG" ]; then
    ts=`date '+%FT%T'`
    echo "$ts > $1"
  fi
}
export -f timestamp
