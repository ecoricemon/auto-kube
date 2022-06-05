#!/bin/sh

echo "=================================================================="
echo "Initialize cluster..."
echo "=================================================================="

sudo kubeadm init --cri-socket=/run/containerd/containerd.sock --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "Done"
echo "Please copy the above kubeadm command with token"
