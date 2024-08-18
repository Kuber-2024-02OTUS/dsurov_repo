#!/bin/bash

# Добавление ключа репозитория Kubernetes
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Добавление репозитория Kubernetes в список источников
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Обновление списка пакетов
sudo apt-get update

# Разблокировка обновления kubeadm
sudo apt-mark unhold kubeadm

# Установка конкретной версии kubeadm
sudo apt-get install -y kubeadm=1.30.3-*

# Блокировка версии kubeadm
sudo apt-mark hold kubeadm

# Проверка версии kubeadm
kubeadm version

# Обновление kubectl
curl -LO "https://dl.k8s.io/release/v1.30.3/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Проверка версии kubectl
kubectl version

# План обновления с помощью kubeadm
sudo kubeadm upgrade plan

# Даем время для плавного завершения kube-apiserver
# killall -s SIGTERM kube-apiserver # Раскомментируйте для завершения kube-apiserver
sleep 40 # Ждем завершения текущих запросов

# Подтягиваем образы для обновления
kubeadm config images pull

# Проверка доступных версий kubelet
apt-cache policy kubelet

# Разблокировка обновления kubelet
sudo apt-mark unhold kubelet

# Обновление kubelet до нужной версии
sudo apt-get update && sudo apt-get install -y kubelet=1.30.3-1.1

# Применение обновления
sudo kubeadm upgrade apply v1.30.3