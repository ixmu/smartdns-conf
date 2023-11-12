#!/bin/sh

download_files() {
    curl -o /etc/smartdns/smartdns.conf https://raw.githubusercontent.com/ixmu/smartdns-conf/main/smartdns.conf
    curl -o /etc/smartdns/hosts.conf https://raw.githubusercontent.com/ixmu/smartdns-conf/main/hosts.conf
    curl -o /etc/smartdns/blacklist-ip.conf https://raw.githubusercontent.com/ixmu/smartdns-conf/main/blacklist-ip.conf
    curl -o /etc/smartdns/proxy-domain-list.conf https://raw.githubusercontent.com/ixmu/smartdns-conf/main/proxy-domain-list.conf
    curl -o /etc/smartdns/direct-domain-list.conf https://raw.githubusercontent.com/ixmu/smartdns-conf/main/proxy-direct-list.conf
}

restart_smartdns() {
    /etc/init.d/smartdns restart
}

while true; do
    download_files

    if [ $? -eq 0 ]; then
        restart_smartdns
        break
    else
        echo "Download failed. Retrying in 30 seconds..."
        sleep 30
    fi
done