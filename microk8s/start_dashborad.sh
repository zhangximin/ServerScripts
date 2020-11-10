#!/bin/bash

#####################################
## Access dashborad
## microk8s.kubectl proxy --accept-hosts=.* --address=0.0.0.0

## microk8s.kubectl -n kube-system edit deploy kubernetes-dashboard -o yaml
## add [- --enable-skip-login] to args: under containers of spec.
#####################################

echo "Browse url: http://192.168.1.210:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/"
echo "--"

microk8s.kubectl proxy --accept-hosts=.* --address=0.0.0.0
