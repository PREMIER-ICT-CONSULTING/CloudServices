#!/bin/bash

echo "\$1 = '$1'"
if [ "$1" -eq "" ]; then
    KUBE_CTL = "microk8s kubectl"
else
    KUBE_CTL = $1


echo "### Download Latest ArgoCD Standalone config file... \n\n"
eval "cd ./control_plane/orchestrator && wget \"https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml\" "