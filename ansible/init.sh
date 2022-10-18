#!/bin/sh

if [ $# -lt 1 ]; then
    echo "Usage: ./init.sh type"
    echo "type: vbox | utm"
	exit 0
fi

type=$1

if [ $type = "vbox" ]; then
	for remote in 10.0.3.10 10.0.3.11; do
		ssh-copy-id -o ProxyJump="kube@localhost:8022" kube@$remote 2>/dev/null
	done
	ansible-playbook -i inventories/inv-vbox.yaml -K playbooks/init.yaml
elif [ $type = "utm" ]; then
	for remote in 192.168.0.210 192.168.0.211; do
		ssh-copy-id kube@$remote 2>/dev/null
	done
	ansible-playbook -i inventories/inv-utm.yaml -K playbooks/init.yaml
fi

