#!/bin/bash

if [ $# -eq 1 ];then
	microk8s kubectl exec --stdin --tty $1 -- bin/bash
else
	echo "Usage: $0 [pod name]"
fi
