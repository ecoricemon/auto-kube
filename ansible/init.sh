#!/bin/sh

for remote in 192.168.128.10 192.168.128.11; do
	ssh-copy-id kube@$remote
done

ansible-playbook -i inventories/inv-utm.yaml -K playbooks/init.yaml

