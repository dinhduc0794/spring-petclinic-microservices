#!/bin/bash
set -e  # Dừng script ngay lập tức nếu có lệnh bị lỗi

echo "--------------------------------------------------"
echo "🚀 STARTING BOOTSTRAP PROVISIONING..."
echo "--------------------------------------------------"

# 1. Cấu hình Hostname và IP Resolution
echo "[TASK 1] Setup /etc/hosts"
cat >> /etc/hosts <<EOF
192.168.56.10 master-node
192.168.56.11 worker-ops
192.168.56.12 worker-app
EOF

# 2. Tắt Swap (Bắt buộc cho Kubernetes hoạt động ổn định)
echo "[TASK 2] Disable Swap"
swapoff -a
sed -i '/swap/d' /etc/fstab

# 3. Cài đặt các gói phụ thuộc cơ bản
echo "[TASK 3] Install Basic Tools"
apt-get update -y > /dev/null
apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg2 net-tools iputils-ping telnet git vim > /dev/null

# 4. Cài đặt Container Runtime (Docker Engine)
echo "[TASK 4] Install Docker Engine"
# Add Docker's official GPG key:
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y > /dev/null

# Install Docker
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin > /dev/null

# 5. Cấu hình Docker Daemon (Cgroup Driver = Systemd)
# Đây là Best Practice cho Kubernetes để quản lý tài nguyên đồng nhất với OS
echo "[TASK 5] Configure Docker Daemon"
cat <<EOF | tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

systemctl enable docker > /dev/null
systemctl daemon-reload
systemctl restart docker

# 6. Phân quyền cho user 'vagrant'
echo "[TASK 6] Add user to docker group"
usermod -aG docker vagrant

echo "--------------------------------------------------"
echo "✅ BOOTSTRAP COMPLETED SUCCESSFULLY!"
echo "--------------------------------------------------"