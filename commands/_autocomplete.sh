#!/usr/bin/env bash
# auto-completion for ./do

if [[ -n ${ZSH_VERSION-} ]]; then
  autoload bashcompinit && bashcompinit
fi

# sets $list_commands with the list of commands available
# (from . and $XDO_PATH)
_xdo_listCommands () {
  local xdo_path=".:$XDO_HOME:$XDO_PATH"
  local IFS=':'
  local folders
  set -f
  folders=( $xdo_path )
  set +f
  list_commands=''
  for d in "${folders[@]}"
  do
    local commands="$d/commands"
    if [ -d "$commands" ]; then
      local newActions=`find $commands -type f | grep .sh | sed -e 's/.*commands\/\(.*\)\.sh$/\1/' -e '/^_/ d'`
      list_commands="$list_commands $newActions"
    fi
  done
}

_xdo_autocomplete () {
  source $XDO_HOME/commands/_internal.sh
  findRoot
  if [ -z "$xdo_root" ]; then
    return 0;
  fi

  cd $xdo_root/

  list_stages=`[ -d $stages ] && ls -d stages/*/ | sed 's/stages\/\(.*\)\//\1/'`
  _xdo_listCommands
  list_applications=`[ -d applications ] && ls -d applications/*/ | sed -e's/applications\/\(.*\)\/$/\1/'`
  list_infra=`[ -d infra ] && ls -d infra/*/ | sed -e's/infra\/\(.*\)\/$/\1/'`
  list_services=`[ -d services ] && ls -d services/*/ | sed -e's/services\/\(.*\)\/$/\1/'`
  list_app_services_plus=":dev +applications +services $list_applications $list_services"
  list_full=`echo "+infra $list_infra $list_app_services_plus"`

  case $COMP_CWORD in
    1)
    # 1st argument is a stage: directory in stages/
      COMPREPLY=($list_stages)
      ;;
    2)
    # 2nd argument is an action, a .sh in stages/
      COMPREPLY=($list_commands)
      ;;
    3)
    # 3rd argument is...
      stg=${COMP_WORDS[1]}
      action=${COMP_WORDS[2]}
      # an application or a service IF 2nd is build, push, or pull
      if [ $action = "build" ] || [ $action = "push" ]; then
        COMPREPLY=($list_app_services_plus)
      fi
      if [ $action = "provision" ] || [ $action = "pull" ]; then
        COMPREPLY=($list_full)
      fi
      # a stage IF 2nd is deploy
      if [ $action = "deploy" ]; then
        COMPREPLY=($list_stages)
      fi
      ;;
    *)
      # an application or service in all other cases
      COMPREPLY=($list_full)
    ;;
  esac
  return 0
}

complete -F _xdo_autocomplete 'xdo'
