apt-get update
apt-get install openvpn easy-rsa curl

#IPADDR=$(curl -s http://ip/metadata/v1/interfaces/public/0/ipv4/address)

gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz > /etc/openvpn/server.conf
sed -ie 's/dh dh1024.pem/dh dh2048.pem/' /etc/openvpn/server.conf
sed -ie 's/;push "redirect-gateway def1 bypass-dhcp"/push "redirect-gateway def1 bypass-dhcp"/' /etc/openvpn/server.conf
sed -ie 's/;push "dhcp-option DNS 208.67.222.222"/push "dhcp-option DNS 208.67.222.222"/' /etc/openvpn/server.conf
sed -ie 's/;push "dhcp-option DNS 208.67.220.220"/push "dhcp-option DNS 208.67.220.220"/' /etc/openvpn/server.conf
sed -ie 's/;user nobody/user nobody/' /etc/openvpn/server.conf
sed -ie 's/;group nogroup/group nogroup/' /etc/openvpn/server.conf
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -ie 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf

ufw allow ssh
ufw allow 8166
#ufw allow 1194/udp
#ufw allow 1723/tcp
#ufw allow 47/tcp

sed -ie 's/DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/' /etc/default/ufw
sed -i "1i# START OPENVPN RULES\n# NAT table rules\n*nat\n:POSTROUTING ACCEPT [0:0]\n# Allow traffic from OpenVPN client to eth0\n\n-A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE\nCOMMIT\n# END OPENVPN RULES\n\n\n#MOVE TO *filter!!!!\n-A ufw-before-input -p 47 -j ACCEPT\n\n\n#PPTP\n-A ufw-before-input -p tcp -s 0.0.0.0/0 --sport 1723 -j ACCEPT\n-A ufw-before-output -p tcp -d 0.0.0.0/0 --dport 1723 -j ACCEPT\n\n" /etc/ufw/before.rules
ufw --force enable

cp -r /usr/share/easy-rsa/ /etc/openvpn
mkdir /etc/openvpn/easy-rsa/keys
sed -ie 's/KEY_NAME="EasyRSA"/KEY_NAME="server"/' /etc/openvpn/easy-rsa/vars
openssl dhparam -out /etc/openvpn/dh2048.pem 2048
cd /etc/openvpn/easy-rsa && . ./vars
# Optionally set indentity information for certificates:
# - export KEY_COUNTRY="<%COUNTRY%>" # 2-char country code
# - export KEY_PROVINCE="<%PROVINCE%>" # 2-char state/province code
# - export KEY_CITY="<%CITY%>" # City name
# - export KEY_ORG="<%ORG%>" # Org/company name
# - export KEY_EMAIL="<%EMAIL%>" # Email address
# - export KEY_OU="<%ORG_UNIT%>" # Orgizational unit / department

export KEY_COUNTRY="CN"
export KEY_PROVINCE="BJ"
export KEY_CITY="BJ"
export KEY_ORG="Tiertime"
export KEY_EMAIL="simon@tiertime.net"
export KEY_OU="UP3D"

cd /etc/openvpn/easy-rsa && ./clean-all
cd /etc/openvpn/easy-rsa && ./build-ca --batch
cd /etc/openvpn/easy-rsa && ./build-key-server --batch server
cp /etc/openvpn/easy-rsa/keys/server.crt /etc/openvpn
cp /etc/openvpn/easy-rsa/keys/server.key /etc/openvpn
cp /etc/openvpn/easy-rsa/keys/ca.crt /etc/openvpn
service openvpn start

echo "OpenVPN installed successfully."