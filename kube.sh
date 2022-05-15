#!/bin/sh

my_exit() {
	echo "Usage: ./kube.sh [run|ip|ssh|pf] [ext|0|1|2|pn]"
	echo "run : Run a virtual machine"
	echo "ip : Get IP addresses of a virtual machine"
	echo "ssh : Login to a virtual machine"
	echo "pf : Port forward"
	echo "m, 1, 2, 3 : For each virtual machine"
	echo "pn : A port number to be forwarded, which is valid if it's in 8000 ~ 65535"
	exit
}

VM_USER=kube
SSH_PORT=8022
VM0_IP=10.0.3.10
VM1_IP=10.0.3.11
VM2_IP=10.0.3.12

SSH_CMD=my_exit
PF_CMD=my_exit

if [ $# -eq 2 ]; then
	if [ $2 = "ext" ]; then
		VM_NAME="ubuntu server ext"
		SSH_CMD="ssh -p $SSH_PORT $VM_USER@localhost"
	elif [ $2 = "0" ]; then
		VM_NAME="ubuntu server 0"
		SSH_CMD="ssh -p $SSH_PORT -t $VM_USER@localhost ssh $VM_USER@$VM0_IP"
	elif [ $2 = "1" ]; then
		VM_NAME="ubuntu server 1"
		SSH_CMD="ssh -p $SSH_PORT -t $VM_USER@localhost ssh $VM_USER@$VM1_IP"
	elif [ $2 = "2" ]; then
		VM_NAME="ubuntu server 2"
		SSH_CMD="ssh -p $SSH_PORT -t $VM_USER@localhost ssh $VM_USER@$VM2_IP"
	elif [ $2 -ge 8000 ] && [ $2 -le 65535 ]; then
		PF_CMD="ssh -L$2:localhost:$2 $VM_USER@$VM_MASTER_IP"
	else
		my_exit
	fi

	if [ $1 = "run" ]; then	
		VBoxManage startvm "$VM_NAME" --type headless
	elif [ $1 = "ip" ]; then
		VBoxManage guestproperty enumerate "$VM_NAME" | grep IP
	elif [ $1 = "ssh" ]; then
		$SSH_CMD
	elif [ $1 = "pf" ]; then
		$PF_CMD
	else
		my_exit
	fi
else
	my_exit
fi

