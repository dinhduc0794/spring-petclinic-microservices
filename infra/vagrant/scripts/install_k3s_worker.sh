#!/bin/bash
set -e

# --- SỬA Ở ĐÂY: Lấy IP từ enp0s8 ---
CURRENT_IP=$(ip -4 addr show enp0s8 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
MASTER_IP="192.168.56.10"

echo "[WORKER] STARTING K3S AGENT INSTALLATION on $CURRENT_IP..."

# 1. Dọn dẹp Docker cũ
echo "Cleaning up Docker/Kubeadm..."
sudo systemctl stop docker
sudo systemctl disable docker
sudo kubeadm reset -f || true
sudo rm -rf /etc/cni/net.d

# 2. Đọc Token
TOKEN_FILE="/vagrant/node-token"
if [ ! -f "$TOKEN_FILE" ]; then
  echo "ERROR: Token file not found at $TOKEN_FILE"
  exit 1
fi
K3S_TOKEN=$(cat $TOKEN_FILE)

# 3. Cài đặt K3s Agent (Worker)
# --- SỬA Ở ĐÂY: eth1 -> enp0s8 ---
echo "Joining Cluster at $MASTER_IP..."
curl -sfL https://get.k3s.io | K3S_URL=https://$MASTER_IP:6443 K3S_TOKEN="$K3S_TOKEN" INSTALL_K3S_EXEC="agent --node-ip=$CURRENT_IP --flannel-iface=enp0s8" sh -

echo "[WORKER] JOINED CLUSTER SUCCESSFULLY!"