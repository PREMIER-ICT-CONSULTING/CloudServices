#!/bin/bash

SHORT=k,h
LONG=kubectl-cmds,help
OPTS=$(getopt -a -n auto_installer --options $SHORT --longoptions $LONG -- "$@")

USAGE="    Usage:  \$ ./auto_installer.sh [ [-k|--kubectl-cmds] \"COMMANDS\" ] | [ -h|--help ]"

eval set -- "$OPTS"

while :
do
  case "$1" in
    -k | --kubectl-cmds )
      shift
      KUBE_CTL="$@"
      break
      ;;
    -h | --help )
      echo ""
      echo "Auto deploy using 'kubectl' or specify another command tool. "
      echo ""
      echo "$USAGE"
      break
      ;;
    - | -- )
      echo "Invalid option at '$1', Try:"
      echo ""
      echo "$USAGE"
      break
      ;;
    * )
      if [ -z "$@" ]
      then
        KUBE_CTL="kubectl"
      else
        echo "Invalid arguments '$@', Try:"
        echo ""
        echo "$USAGE"
      fi
      break
      ;;
  esac
done

echo "KUBE_CTL = '$KUBE_CTL'"