#!/bin/bash

HOME_DIR=$(eval "pwd")
ARGOCD_SA_INSTALLER="https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
ARGOCD_HA_INSTALLER="https://github.com/argoproj/argo-cd/blob/master/manifests/ha/install.yaml"

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

if [ -z "$K8S_CTL_VER" ] ;
then
  echo -e "Could not verify that the '$KUBE_CTL' tools are intalled or accessable on the default path...\n"
  # echo -e "\nDo you wish to proceed with the installation attempt?"

  while IFS=: read -p "Do you wish to proceed with the installation attempt anyways? (y|N) : " -r yn
    do
      case $yn in
        [Yy]* )
          echo -e "\n"
          break
          ;;

        [Nn]* ) 
          echo -e "\nUser aborted the installation?"
          exit 1
          ;;

        * )
          echo -e "\nUser aborted the installation?"
          exit 1
          ;;

    esac
  done

fi


while IFS=: read -p "Do you wish to install 'ARGO CD' in High Availaility deployment? (y|n) : " -r yn
  do
    case $yn in
      [Yy]* )
        # echo -e "\n### Install latest ArgoCD Standalone config file... \n\n"
        ARGOCD_INSTALLER=$ARGOCD_HA_INSTALLER
        INSTALLER_SCRIPT="install_ha.yaml"
        break
        ;;
      
      [Nn]* )
        ARGOCD_INSTALLER=$ARGOCD_SA_INSTALLER
        INSTALLER_SCRIPT="install.yaml"
        break
        ;;
      
      * )
        echo -e "Please answer (Y|y) or yes or (N|n) for no..."
        ;;
      
  esac
done


while IFS=: read -p "Do you wish to check online for an updated install script? (y|n) : " -r yn
  do
    case $yn in
      [Yy]* )
        eval "mv -f $HOME_DIR/control_plane/orchestrator/$INSTALLER_SCRIPT $HOME_DIR/control_plane/orchestrator/$INSTALLER_SCRIPT.old"
        echo -e "\n### Download Latest ArgoCD Standalone config file... \n\n"
        eval "cd $HOME_DIR/control_plane/orchestrator && /
            wget '$ARGOCD_INSTALLER' "
        break
        ;;
      
      [Nn]* )
        break
        ;;
      
      * )
        echo -e "Please answer (Y|y) or yes or (N|n) for no..."
        ;;
      
  esac
done


# eval "git config --global user.name ""PICTC"" "
# eval "git config --global user.email ""support@premier-ictc.com"" "

eval "cd $HOME_DIR"

echo -e "\n### Deploy 'ArgoCD'- Standalone deployment into the 'control-plane' namespace... \n\n"
eval "$KUBE_CTL create namespace control-plane;"
eval "$KUBE_CTL apply -n control-plane -f $HOME_DIR/control_plane/orchestrator/$INSTALLER_SCRIPT"

echo -e "\n### Deploy 'Traefik' pod into the 'control-plane' namespace... \n\n"
eval "$KUBE_CTL apply -n control-plane -f $HOME_DIR/control_plane/reverse_proxy -R"

echo -e "\n### Deploy 'whoami' pod into the 'control-plane' namespace... \n\n"
# eval "$KUBE_CTL create namespace whoami"
eval "$KUBE_CTL apply -n control-plane -f $HOME_DIR/control_plane/testing -R"

echo -e "\n### Create Ingress rule for 'ArgoCD Server' web UI via the FQDN... \n\n"
eval "$KUBE_CTL create ingress public --class=default \
        --rule=""*.csp.cloud.premier-ictc.com/=traefik-web-service:80"" \
        --rule=""*.cloud.premier-ictc.com/=traefik-web-service:80"" \
        --rule=""cpanel.cloud.premier-ictc.com/=traefik-dashboard-service:8080"" "

echo -e "\n[Debug] Logging: 'Successful installation!'"
exit 0
