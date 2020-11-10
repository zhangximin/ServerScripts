#!/bin/bash

VER=1.27.4

if [ -f /usr/bin/docker-compose ] || [ -f /usr/local/bin/docker-compose ];then
    OVER=`docker-compose --version`
    if (whiptail --title "Old version detected!" --yesno --defaultno --yes-button "Continue" --cancel-button "Cancel" "${OVER} has installed, CONTINUE ???" 8 78); then

        if [ ! -x /usr/bin/curl ];then
                sudo apt update
                sudo apt install curl
        fi

        sudo curl -L "https://github.com/docker/compose/releases/download/${VER}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

        sudo chmod +x /usr/local/bin/docker-compose

        sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

        docker-compose --version
    fi
fi

