#!/bin/bash

#disable swap
sudo sed -i '/ swap / s/^/#/' /etc/fstab
swapoff -a

# Forwarding IPv4 and letting iptables see bridged traffic
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# Create keyrings directory
sudo mkdir -m 755 /etc/apt/keyrings

# Update the apt package index and install packages needed for Kubernetes
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# Download the public signing key for the Kubernetes package repositories
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add the appropriate Kubernetes apt repository
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update the apt package index and install kubelet, kubeadm, and kubectl
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl containerd
sudo apt-mark hold kubelet kubeadm kubectl
sudo mkdir -p $HOME/.kube

sudo mkdir -p /etc/containerd/
containerd config default > /etc/containerd/config.toml

# Путь к файлу конфигурации
CONFIG_FILE="/etc/containerd/config.toml"

# Используем sed для изменения значения SystemdCgroup
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' "$CONFIG_FILE"

# Перезапускаем containerd
systemctl restart containerd

echo "Значение SystemdCgroup успешно изменено на true и containerd перезапущен."
