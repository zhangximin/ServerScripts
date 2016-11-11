#!/bin/bash
set -e

if [ $# == 1 ];then

    clientName=$1;

    export SERVERADDR="dev.tiertime.net 8194"

    cp ./client.ovpn.0 /etc/openvpn/easy-rsa/keys/${clientName}.ovpn
    cd /etc/openvpn/easy-rsa
    source ./vars
    ./build-key --batch ${clientName}

    sed -ie 's/;proto tcp/proto tcp/' /etc/openvpn/easy-rsa/keys/${clientName}.ovpn
    sed -ie 's/proto udp/;proto udp/' /etc/openvpn/easy-rsa/keys/${clientName}.ovpn
    sed -ie "s/my-server-1 1194/$SERVERADDR/" /etc/openvpn/easy-rsa/keys/${clientName}.ovpn
    sed -ie 's/;user nobody/user nobody/' /etc/openvpn/easy-rsa/keys/${clientName}.ovpn
    sed -ie 's/;group nogroup/group nogroup/' /etc/openvpn/easy-rsa/keys/${clientName}.ovpn
    sed -ie 's/ca ca.crt//' /etc/openvpn/easy-rsa/keys/${clientName}.ovpn
    sed -ie "s/cert client.crt//" /etc/openvpn/easy-rsa/keys/${clientName}.ovpn
    sed -ie "s/key client.key//" /etc/openvpn/easy-rsa/keys/${clientName}.ovpn


    echo "<ca>" >> /etc/openvpn/easy-rsa/keys/${clientName}.ovpn
    cat /etc/openvpn/ca.crt >> /etc/openvpn/easy-rsa/keys/${clientName}.ovpn
    echo "</ca>" >> /etc/openvpn/easy-rsa/keys/${clientName}.ovpn
    echo "<cert>" >> /etc/openvpn/easy-rsa/keys/${clientName}.ovpn
    cat /etc/openvpn/easy-rsa/keys/${clientName}.crt >> /etc/openvpn/easy-rsa/keys/${clientName}.ovpn
    echo "</cert>" >> /etc/openvpn/easy-rsa/keys/${clientName}.ovpn
    echo "<key>" >> /etc/openvpn/easy-rsa/keys/${clientName}.ovpn
    cat /etc/openvpn/easy-rsa/keys/${clientName}.key >> /etc/openvpn/easy-rsa/keys/${clientName}.ovpn
    echo "</key>" >> /etc/openvpn/easy-rsa/keys/${clientName}.ovpn

else
    echo ""
    echo "USAGE:$0 ClientName"
fi

