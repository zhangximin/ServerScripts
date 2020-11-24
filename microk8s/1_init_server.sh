#!/bin/bash

tString=`date "+%Y%m%d%H%M%S%N"`

if [ $# -eq 2 ];then
	tIP=$1
	tHostName=$2
	echo "Target IP: $1"
	read -p "Are you sure? " -n 1 -r
	echo    # (optional) move to a new line
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		echo "Resolving dependencies ..."
		dpkg -s sshpass 2>/dev/null >/dev/null || sudo apt-get -y install sshpass
		echo "Done."

		ssh-keygen -R ${tHostName}
		ssh-keygen -R ${tIP}
		ssh-keygen -R ${tHostName},${tIP}
		ssh-keyscan -H ${tHostName},${tIP} >> ~/.ssh/known_hosts
		ssh-keyscan -H ${tIP} >> ~/.ssh/known_hosts
		ssh-keyscan -H ${tHostName} >> ~/.ssh/known_hosts

		read -s -p "Please input REMOTE server[${tIP}] sudo password: " -r
		echo ""
		tPs=$REPLY

		sshpass -p ${tPs} ssh ${USER}@${tIP} "ssh-keygen -o -t rsa -b 4096 -P '' -N '' -f ~/.ssh/id_rsa"

		if [ -f ~/.ssh/authorized_keys ];then
			sshpass -p ${tPs} scp ~/.ssh/authorized_keys ${USER}@${tIP}:~/.ssh/
		fi

		echo "Adding ${USER} to sudoers."
		sshpass -p ${tPs} ssh -tt ${USER}@${tIP} "echo ${tPs}| sudo -S -s /bin/bash -c 'echo \"${USER} ALL=(ALL:ALL) NOPASSWD:ALL\" >> /etc/sudoers'"
		echo "Done."

		echo "Updating system ... ..."
		sshpass -p ${tPs} ssh ${USER}@${tIP} "sudo apt-get upgrade -y"
		sshpass -p ${tPs} ssh ${USER}@${tIP} "sudo apt-get update -y"
		echo "Done."

		read -p "If reboot system NOW ? " -n 1 -r
		echo    # (optional) move to a new line
		if [[ $REPLY =~ ^[Yy]$ ]]
		then
			sshpass -p ${tPs} ssh ${USER}@${tIP} "sudo shutdown -r now"
		else
			echo "Reboot host ${tIP} needed."
		fi

		echo ""
		echo "----------"
		echo "All Done."
		echo "${tString}"
	fi
else
	echo "======================================"
	echo "Usag:$0 [ Target IP ] [ Host Name ]"
fi

