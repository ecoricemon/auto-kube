#!/bin/sh

if [ $# -lt 1 ]; then
    echo "Usage: ./init.sh type"
    echo "type: vbox | utm"
    exit 0
fi

type=$1

if [ $type = "vbox" ]; then
	ansible-playbook -i inventories/inv-vbox.yaml -K playbooks/make-cluster.yaml
elif [ $type = "utm" ]; then
	ansible-playbook -i inventories/inv-utm.yaml -K playbooks/make-cluster.yaml
fi

