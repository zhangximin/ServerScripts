1.make dir: mkdir -p ~/temp/
2.grep "Android" and before " - -" is ip.

sudo tail -f access.log|grep --line-buffered Android|grep --line-buffered -oP '.*?(?=\ \-\ \-)' > ~/temp/ips.log
