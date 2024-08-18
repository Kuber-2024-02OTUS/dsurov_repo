curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-mark unhold kubeadm
sudo apt-get update
sudo apt-get install -y kubeadm=1.29.7-*
sudo apt-mark hold kubeadm
kubeadm version
#вывести ноду из обслуживания
kubectl drain utestworker1 --ignore-daemonsets

# Обновление kubectl
sudo apt-mark unhold kubectl
curl -LO "https://dl.k8s.io/release/v1.29.7/bin/linux/amd64/kubectl"
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
sudo apt-mark hold kubectl

# Проверка версии kubectl
kubectl version

#проверить доступные версии kubelet
apt-cache policy kubelet
#обновить kubelet
sudo apt-mark unhold kubelet
sudo apt-get update && apt-get install -y kubelet=1.29.7-1.1
sudo systemctl daemon-reload
sudo systemctl restart kubelet
sudo apt-mark hold kubelet
#ввести ноду в обслуживание
kubectl uncordon utestworker1