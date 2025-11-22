#!/bin/bash
set -e

echo "zINSTALLING KUBERNETES WORKER..."

# 1. Cấu hình Containerd & Sysctl (FIX LỖI CRI & NETWORK)
echo "Configuring containerd prerequisites..."
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system

# 2. Cài đặt Kubeadm, Kubelet
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

if [ ! -d "/etc/apt/keyrings" ]; then
  sudo mkdir -p /etc/apt/keyrings
fi

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg --yes
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# 3. FIX LỖI CONTAINERD (SystemdCgroup) - BẮT BUỘC TRÊN WORKER NỮA
echo "Fixing containerd configuration..."
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
sudo systemctl restart containerd

# 4. Join vào Cluster
if [ -f /vagrant/join_command.sh ]; then
  echo "🔗 Joining the cluster..."
  sudo bash /vagrant/join_command.sh
else
  echo "❌ ERROR: join_command.sh not found! Check Master node."
fi

echo "WORKER NODE JOINED SUCCESSFULLY!"