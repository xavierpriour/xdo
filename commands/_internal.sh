#!/usr/bin/env bash

# sets $xdo_root to the absolute path of the current project root,
# if any.
# project root is the ancestor of . where stages are defined
function findRoot() {
  xdo_root=''
  local current=$PWD
  while [ -n "$current" ]; do
    if [ -d "$current/stages" ]; then
      xdo_root="$current"
      break;
    fi
    current=`echo $current | sed -e"s/\(.*\)\/.*$/\1/"`
  done
}
