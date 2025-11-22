#!/bin/bash
set -e

echo "[MASTER] STARTING K3S INSTALLATION..."

# 1. Dọn dẹp Docker cũ
echo "Cleaning up Docker/Kubeadm..."
sudo systemctl stop docker
sudo systemctl disable docker
sudo kubeadm reset -f || true
sudo rm -rf /etc/cni/net.d

# 2. Cài đặt K3s Server (Master)
# --- SỬA Ở ĐÂY: eth1 -> enp0s8 ---
echo "Installing K3s Server..."
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --node-ip=192.168.56.10 --flannel-iface=enp0s8 --write-kubeconfig-mode 644 --disable=traefik" sh -

# 3. Lưu Token
echo "Saving Node Token to shared folder..."
while [ ! -f /var/lib/rancher/k3s/server/node-token ]; do
  sleep 2
done
cp /var/lib/rancher/k3s/server/node-token /vagrant/node-token

# 4. Cấu hình kubectl
echo "🛠 Configuring kubectl..."
mkdir -p /home/vagrant/.kube
cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube
echo "alias k=kubectl" >> /home/vagrant/.bashrc
echo "alias kubectl='sudo k3s kubectl'" >> /home/vagrant/.bashrc

echo "[MASTER] SETUP COMPLETED! Token saved to /vagrant/node-token"