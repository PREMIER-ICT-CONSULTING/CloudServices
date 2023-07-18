#!/bin/bash

echo "\$1 = '$1'"
if [ "$1" -eq "" ]; then
    KUBE_CTL = "microk8s kubectl"
else
    KUBE_CTL = $1