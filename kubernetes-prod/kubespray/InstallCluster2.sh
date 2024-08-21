#!/bin/bash

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




