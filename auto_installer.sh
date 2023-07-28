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
      echo -e "\nUsing the '$KUBE_CTL' K8s control command line tools!\n"
      break
      ;;

    -h | --help )
      echo -e "Auto deployment using 'kubectl' or some other K8s ctl command tool. \n$USAGE\n"
      exit 0
      ;;

    * )
      if [ !$@ ]
      then
        KUBE_CTL="kubectl"
        echo -e "\nUsing default '$KUBE_CTL' command set!\n"
        break
      else
        echo -e "\nInvalid arguments '$@', Try:\n$USAGE\n"
      fi
      ;;

  esac
done

K8S_CTL_VER=$(eval "$KUBE_CTL version ")
echo -e " [$KUBE_CTL version] = '$K8S_CTL_VER' \n"

if [ -n "$K8S_CTL_VER" ] ;
then
  echo -e "Could not verify that the '$KUBE_CTL' tools are intalled or accessable on the default path..."
  echo -e "\nDo you wish to proceed with the installation attempt?"

  while IFS='Do you wish to proceed with the installation attempt sadadvdy ' read -r yn
    do
      case $yn in
        [Yy]* ) 
          break
          ;;

        [Nn]* ) 
          echo -e "\n\nUser aborted the installation?"
          exit 1
          ;;

    esac
  done

fi

echo "[Debug] Logging: 'Exit 0'"
exit 0

while : 
  do
    read -p "Do you wish to check online for an updated install script? (y|n) " yn
    case $yn in
      [Yy]* )
        echo -e "\n### Download Latest ArgoCD Standalone config file... \n\n"
        eval "cd ./control_plane/orchestrator && wget 'https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml'"
        break
        ;;
      [Nn]* )
        break
        ;;
      * )
        echo -e "Please answer (Y|y) or yes or (N|n) for no."
        ;;
  esac
done

# eval "git config --global user.name ""PICTC"" "
# eval "git config --global user.email ""support@premier-ictc.com"" "



# echo "### Deploy 'ArgoCD Standalone' deployment into the 'control_plane' namespace... \n\n"
# eval "$KUBE_CTL create namespace control_plane;"
# eval "$KUBE_CTL apply -n ns-control_plane -f ./ns-control_plane/po-orchestrator/install.yaml"

# echo "### Create Ingress rule for 'ArgoCD Server' web UI via the FQDN... \n\n"
# eval "$KUBE_CTL create ingress --rule=\"cpanel.csp.cloud.premier-ictc.com/=svc1:80\" "

# echo "### Deploy 'WhoAmI' pod into the 'control_plane' namespace... \n\n"
# eval "$KUBE_CTL create namespace whoami"
# eval "$KUBE_CTL apply -f ./ns-control_plane/po-testing -R"