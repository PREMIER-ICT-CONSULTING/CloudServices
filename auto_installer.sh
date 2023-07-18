#!/bin/bash

echo "\$1 = '$1'"
if [ -z "$1" ]
then
    KUBE_CTL = "microk8s kubectl"
else
    KUBE_CTL = $1
fi

echo "KUBE_CTL = '$KUBE_CTL' "