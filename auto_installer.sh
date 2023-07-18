#!/bin/bash

SHORT=k,h
LONG=kubectl-cmds,help
OPTS=$(getopt -a -n auto_installer.sh --options $SHORT --longoptions $LONG -- "$@")

USAGE="    Usage:  \$ ./auto_installer.sh [ [-k|--kubectl-cmds] \"COMMANDS...\" ] | [ -h|--help ]"

eval set -- "$OPTS"

while :
do
  case "$1" in
    -k | --kubectl-cmds )
      shift 2;
      KUBE_CTL="$@"
      echo ""
      echo "Using default 'kubectl' command set!"
      echo ""
      break
      ;;
    -h | --help )
      echo "Auto deployment using 'kubectl' or some other K8s ctl command tool. "
      echo ""
      echo "$USAGE"
      echo ""
      exit 0
      ;;
    * )
      if  [ !$@ ]
      then
        KUBE_CTL="kubectl"
        echo ""
        echo "Using default 'kubectl' command set!"
        echo ""
        #echo "$USAGE"
        break
      else
        echo ""
        echo "Invalid arguments '$@', Try:"
        echo ""
        echo "$USAGE"
        echo "Invalid arguments '$@', Try:"
      else
        KUBE_CTL="kubectl"
      fi
      ;;
  esac
done

echo ""

eval "git config --global user.name ""PICTC"" "
eval "git config --global user.email ""support@premier-ictc.com"" "

echo "### Download Latest ArgoCD Standalone config file... \n\n"
eval "cd ./control_plane/orchestrator && wget \"https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml\" "


# echo "### Deploy 'ArgoCD Standalone' deployment into the 'control_plane' namespace... \n\n"
# eval "$KUBE_CTL create namespace control_plane;"
# eval "$KUBE_CTL apply -n ns-control_plane -f ./ns-control_plane/po-orchestrator/install.yaml"

# echo "### Create Ingress rule for 'ArgoCD Server' web UI via the FQDN... \n\n"
# eval "$KUBE_CTL create ingress --rule=\"cpanel.csp.cloud.premier-ictc.com/=svc1:80\" "

# echo "### Deploy 'WhoAmI' pod into the 'control_plane' namespace... \n\n"
# eval "$KUBE_CTL create namespace whoami"
# eval "$KUBE_CTL apply -f ./ns-control_plane/po-testing -R"