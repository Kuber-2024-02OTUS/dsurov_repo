#!/bin/bash

# Определите переменные для IP-адресов
NODE1_IP="192.168.5.187"
NODE2_IP="192.168.5.148"
NODE3_IP="192.168.5.235"
NODE4_IP="192.168.5.241"
NODE5_IP="192.168.5.231"

# Обновление системы и установка необходимых пакетов
sudo apt-get update -y
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt-get update -y
sudo apt-get install git python3.10 -y

# Установка pip
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3.10 get-pip.py

#установка kubectl
curl -LO "https://dl.k8s.io/release/v1.30.3/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Клонирование репозитория Kubernetes
mkdir kubespray
#git clone https://github.com/kubernetes-sigs/kubespray.git
git clone --depth 1 https://github.com/kubernetes-sigs/kubespray.git
cd kubespray/
pip install -r requirements.txt

# Копирование инвентаря
cp -rfp inventory/sample inventory/mycluster

# Обновление файла инвентаря
declare -a IPS=(192.168.5.187 192.168.5.148 192.168.5.235 192.168.5.241 192.168.5.231)
CONFIG_FILE=inventory/mycluster/hosts.yaml python3.10 contrib/inventory_builder/inventory.py "${IPS[@]}"


# Запуск ansible playbook
ansible-playbook -i inventory/mycluster/hosts.yaml cluster.yml -b -v & --extra-vars "ansible_sudo_pass=9052600**"

# Настройка kube конфигурации
mkdir -p ~/.kube
sudo cp /etc/kubernetes/admin.conf ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config
