#!/bin/sh

echo "=================================================================="
echo "Disable swap..."
echo "=================================================================="

sudo sed -i 's/\/swap/#\/swap/' /etc/fstab
sudo swapoff -a

echo "Done"
