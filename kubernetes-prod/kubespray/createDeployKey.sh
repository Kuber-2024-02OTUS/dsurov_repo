#!/bin/bash

# Определите переменные
USER="dsurov"
MASTER2_IP="192.168.5.187"
MASTER2_IP="192.168.5.148"
MASTER3_IP="192.168.5.235"  # Укажите правильный IP адрес для master3
WORKER1_IP="192.168.5.241"  # Укажите правильный IP адрес для worker1
WORKER2_IP="192.168.5.231"  # Укажите правильный IP адрес для worker2

# Генерация ключей (если еще не сгенерированы)
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""
fi

# Функция для развертывания ключей
echo "------Функция для развертывания ключей----------------"
deploy_keys() {
    local NODE_IP=$1

    # Разворачиваем SSH ключи
    ssh-copy-id "${USER}@${NODE_IP}"
	cat ~/.ssh/id_rsa.pub | ssh "${USER}@${NODE_IP}" 'cat >> ~/.ssh/authorized_keys'
}

# Функция для добавления пользователя в sudoers
echo "------Функция для добавления пользователя в sudoers----------------"
    # Подключаемся к удалённому хосту и добавляем пользователя в sudoers
add_sudo_access(){	
    ssh "${USER}@${NODE_IP}" <<EOF
sleep 5
echo "${USER} ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
EOF
}

# Разворачиваем ключи и добавляем sudo доступ на nodes
for NODE_IP in "$MASTER2_IP" "$MASTER3_IP" "$WORKER1_IP" "$WORKER2_IP"; do
    sleep 5
    deploy_keys "$NODE_IP"
    sleep 10
    add_sudo_access "$NODE_IP"
done