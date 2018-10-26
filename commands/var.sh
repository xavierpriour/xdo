#!/usr/bin/env bash
#
# returns the value of the given var name in the supplied context
# example: xdo dev var BACKUP_URL

echo "${!1}"