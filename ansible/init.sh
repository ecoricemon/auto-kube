#!/bin/sh

ansible-playbook -i inventories/inv-utm.yaml -K playbooks/init.yaml

