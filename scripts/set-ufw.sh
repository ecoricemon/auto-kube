#!/bin/sh

echo "Enter the type you want to apply(c : control-plane, n : node) :"
read sort

if [ $sort = "c" ] || [ $sort = "C" ]; then
    echo "Set firewall for control-plane..."

    sudo ufw enable
    sudo ufw allow ssh

    # Kubernetes
    sudo ufw allow in 6443/tcp
    sudo ufw allow in 2379:2380/tcp
    sudo ufw allow in 10250/tcp
    sudo ufw allow in 10259/tcp
    sudo ufw allow in 10257/tcp

    # Calico
    sudo ufw allow 129/tcp
    sudo ufw allow 4789/udp
    sudo ufw allow in 5473/tcp
    sudo ufw allow in 443/tcp
    sudo ufw allow in 6443/tcp
    sudo ufw allow in 2379/tcp
elif [ $sort = "n" ] || [ $sort = "N" ]; then
    echo "Set firewall for node..."

    sudo ufw enable
    sudo ufw allow ssh

    # Kubernetes
    sudo ufw allow in 10250/tcp
    sudo ufw allow in 30000:32767/tcp

    # Calico
    sudo ufw allow 179/tcp
    sudo ufw allow 4789/udp
    sudo ufw allow in 5473/tcp
    sudo ufw allow in 443/tcp
    sudo ufw allow in 6443/tcp
    sudo ufw allow in 2379/tcp
fi

echo "Done"
