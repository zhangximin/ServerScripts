#!/bin/sh

fstring=`date "+%Y%m%d%H%M%S%N"`

#curl -fsSL https://get.docker.com -o get-docker.sh

# Warning: Always examine scripts downloaded from the internet before running them locally.
#sudo sh get-docker.sh
#sudo usermod -aG docker ${USER}

################################################################
# Manual setup

sudo apt-get update

echo "Installing depanding packages... ..."
sudo apt-get install -f \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
echo "Done."
echo ""
echo ""
echo "Adding gpg key... ..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo "Done."
echo ""

echo "Adding fingerprint 0EBFCD88 ......"
echo ""
sudo apt-key fingerprint 0EBFCD88
#pub   rsa4096 2017-02-22 [SCEA]
#      9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
#uid           [ unknown] Docker Release (CE deb) <docker@docker.com>
#sub   rsa4096 2017-02-22 [S]
echo "-------------------------------"
echo "Done."
echo ""
echo ""

echo "Adding apt repository ... ..."
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
echo "Done."
echo ""
echo ""

sudo apt-get update

echo "Installing docker-ce ... ..."
sudo apt-get install docker-ce docker-ce-cli containerd.io
echo ""
echo "Done."
echo ""
echo ""
#############################################################
#To install a specific version of Docker Engine - Community

#apt-cache madison docker-ce

#sudo apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io

#############################################################
echo "Adding ${USER} to group docker."
sudo usermod -aG docker ${USER}

#echo "Installing docker-runner"
#sudo curl -L --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64
#sudo chmod +x /usr/local/bin/gitlab-runner
#sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
#sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
#sudo gitlab-runner start

echo "Done."
echo ""
echo ""
echo "----------------"
echo "All Done."
echo ${fstring}

