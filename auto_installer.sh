#!/bin/bash

echo "\$1 = '$1'"
if [ "$1" -eq "" ]; then
    KUBE_CTL = "microk8s kubectl"
else
    KUBE_CTL = $1


echo "### Download Latest ArgoCD Standalone config file... \n\n"
cd ./ns-control_plane/po-orchestrator &&  /
    wget https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


echo "### Deploy 'ArgoCD Standalone' deployment into the 'control_plane' namespace... \n\n"
cmd "$KUBE_CTL create namespace control_plane;"
cmd "$KUBE_CTL apply -n ns-control_plane -f ./ns-control_plane/po-orchestrator/install.yaml;"

# echo "### Create Ingress rule for 'ArgoCD Server' web UI via the FQDN... \n\n"
# cmd "$KUBE_CTL create ingress --rule=\"cpanel.csp.cloud.premier-ictc.com/=svc1:80\" "

# echo "### Deploy 'WhoAmI' pod into the 'control_plane' namespace... \n\n"
# cmd "$KUBE_CTL create namespace whoami"
# cmd "$KUBE_CTL apply -f ./ns-control_plane/po-testing -R"
