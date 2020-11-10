#!/bin/bash

###############################################
## For out put font color
## Black        0;30     Dark Gray     1;30
## Red          0;31     Light Red     1;31
## Green        0;32     Light Green   1;32
## Brown/Orange 0;33     Yellow        1;33
## Blue         0;34     Light Blue    1;34
## Purple       0;35     Light Purple  1;35
## Cyan         0;36     Light Cyan    1;36
## Light Gray   0;37     White         1;37

NC='\e[0m' # No Color
RED='\e[31m'
DarkGray='\e[100m'
Bold='\e[1m'
Green='\e[32m'
## printf "I ${RED}love${NC} Simon\n"

##############################################

tString=`date "+%Y%m%d%H%M%S%N"`

if [ $# -eq 1 ];then
	tIP=$1
	echo "Target IP: $1"
	read -p "Are you sure? " -n 1 -r
	echo    # (optional) move to a new line
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		echo "Closing swap... ..."
		ssh ${USER}@${tIP} "sudo swapoff -a"
		ssh ${USER}@${tIP} "sudo sed -i.origin 's/\/swap.img/\#\# \/swap.img/g' /etc/fstab"
		echo "Done."

		echo "Modifing firewall ......"
		ssh ${USER}@${tIP} "sudo iptables -P FORWARD ACCEPT"
		ssh ${USER}@${tIP} "sudo ufw allow in on cbr0 && sudo ufw allow out on cbr0"
		echo "Done."

		echo "Installing microk8s ......"
		ssh ${USER}@${tIP} "sudo snap install microk8s --classic --channel=1.19/stable"
		echo "Done."

		echo "Add current user to group: {microk8s}"
		ssh ${USER}@${tIP} "sudo usermod -a -G microk8s ${USER}"
		ssh ${USER}@${tIP} "mkdir ~/.kube"
		ssh ${USER}@${tIP} "sudo chown -f -R ${USER} ~/.kube"
		echo "Done."

		echo "Adding proxy ......"
		ssh ${USER}@${tIP} "sudo sed -i.origin '/\# NO_PROXY=10\.1\.0\.0\/16\,10\.152\.183\.0\/24/a HTTPS_PROXY=http:\/\/192\.168\.1\.251:8118\\nNO_PROXY=10\.1\.0\.0\/16\,10\.152\.183\.0\/24\,192\.168\.1\.0\/24' /var/snap/microk8s/current/args/containerd-env"
		ssh ${USER}@${tIP} "sudo /bin/bash -c \"echo 'NO_PROXY=10.1.0.0/16,10.152.183.0/24,192.168.1.0/24' >> /etc/environment\""
		echo "Done."

		echo -e "${DarkGray}${Bold}Next you could run fllowing lines at the master of the cluster:${NC}"
		echo ""
		echo -e "${Green}microk8s enable dashboard dns registry istio storage metallb${NC}"
		echo ""
		echo -e "${Green}microk8s kubectl get all --all-namespaces${NC}"
		echo ""
		echo -e "${Green}microk8s add-node${NC}"
		echo ""
		echo -e "${DarkGray}${Bold}Access the Kubernetes dashboard:${NC}"
		echo ""
		echo -e "${Green}microk8s dashboard-proxy${NC}"
		echo ""
		echo "#############################################################"
		echo -e "${DarkGray}${Bold}And run fllowing lines at the node of the cluster:${NC}"
		echo ""
		echo -e "${Green}microk8s enable dns storage${NC}"
		echo ""
		echo -e "${Green}microk8s join ..... [Output from add-node]${NC}"
		echo ""
		echo "----------"
		echo "All Done."
		echo "${tString}"
	fi
else
	echo "======================================"
	echo "Usag:$0 [ Target IP ]"
fi

