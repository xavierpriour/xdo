#!/usr/bin/env bash

# Just echoes some env variable.
# This is useful to test variables in embedded calls.

setTargetList $*

echo "
  STG=$STG
  ACTION=$ACTION
  args=$*

  target_list=$target_list
"