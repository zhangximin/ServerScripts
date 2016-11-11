#!/bin/bash
set -e

if [ $# == 1 ];then

    clientName=$1;

    if [ ! -d $clientName ];then
    if [ ! -f "/etc/openvpn/easy-rsa/keys/${clientName}.crt" ];then

        mkdir $clientName

        sudo ./openKeyGen.sh "${clientName}"

        sudo cp /etc/openvpn/easy-rsa/keys/${clientName}.ovpn ./${clientName}
        sudo cp /etc/openvpn/easy-rsa/keys/${clientName}.crt ./${clientName}
        sudo cp /etc/openvpn/easy-rsa/keys/${clientName}.key ./${clientName}
        sudo cp /etc/openvpn/easy-rsa/keys/ca.crt ./${clientName}

        sudo chown -R simon.simon ./${clientName}

        if [ -f ${clientName}.tar.bz2 ];then
              rm ${clientName}.tar.bz2
        fi

        tar jcvf ./${clientName}.tar.bz2 ./${clientName}

        echo ""
        echo "-----------------------------------------------"
        echo "Create ${clientName} success. You ONLY need ./${clientName}/${clientName}.ovpn for OpenVPN config.";

    else
        echo ""
        echo "file /etc/openvpn/easy-rsa/keys/${clientName}.crt found!"
        echo "Client Name EXIST, Please check /etc/openvpn/easy-rsa/keys/${clientName}.crt"
    fi
    else
        echo ""
        echo "Client Name EXIST, Please check $clientName"
    fi

else
    echo ""
    echo "USAGE:$0 ClientName"
fi

