#!/bin/bash
set -e

echo "INSTALLING KUBERNETES CONTROL PLANE..."

# 1. Cấu hình lại Containerd (FIX LỖI CRI)
echo "Configuring containerd prerequisites..."
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Setup required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# 2. Cài đặt Kubeadm, Kubelet, Kubectl
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# Fix lỗi GPG key cũ bằng cách dùng folder keyrings chuẩn
if [ ! -d "/etc/apt/keyrings" ]; then
  sudo mkdir -p /etc/apt/keyrings
fi

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg --yes
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# 3. FIX LỖI CONTAINERD (SystemdCgroup)
# Đây là bước quan trọng để fix lỗi "unknown service runtime.v1.RuntimeService"
echo "Fixing containerd configuration..."
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
# Bật SystemdCgroup = true
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
# Restart để nhận config
sudo systemctl restart containerd

# 4. Khởi tạo Cluster
echo "Initializing Kubeadm..."
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=192.168.56.10 --ignore-preflight-errors=NumCPU

# 5. Cấu hình kubeconfig
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 6. Cài đặt Calico Network
echo "Installing Calico..."
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml

# 7. Tạo lệnh join
echo "Generating join command..."
kubeadm token create --print-join-command > /vagrant/join_command.sh
chmod +x /vagrant/join_command.sh

echo "MASTER NODE SETUP COMPLETED!"