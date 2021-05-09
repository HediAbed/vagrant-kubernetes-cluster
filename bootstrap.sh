#!/bin/bash
# Docker setup
echo "[Docker Setup]"

echo "[TASK 1] Install docker container engine"
apt-get install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update -y
apt-get install docker-ce -y

# add user to the docker group
echo "[TASK 2] Add a user to the docker group"
usermod -aG docker vagrant

# Enable docker service
echo "[TASK 3] Enable and start docker service"
systemctl enable docker >/dev/null 2>&1
systemctl start docker

# Add sysctl settings; local service-pod access needs net.bridge.bridge-nf-call-iptables=1 
echo "[System configuration & Kubernetes setup]"
echo "[TASK 1] Add sysctl settings"
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-iptables = 1
EOF

# Reload settings
echo "[TASK 2] Reload settings from all system configuration files"
sysctl --system >/dev/null 2>&1

# Disable swap
echo "[TASK 3] Disable and turn off SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a

# Install apt-transport-https pkg
echo "[TASK 4] Installing apt-transport-https pkg"
apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Update hosts file
echo "[TASK 5] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
200.1.1.100 kmaster.example.com kmaster
200.1.1.101 kworker1.example.com kworker1
200.1.1.102 kworker2.example.com kworker2
EOF

# Add the kubernetes sources list 
echo "[TASK 6] Update /etc/hosts file"
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
ls -ltr /etc/apt/sources.list.d/kubernetes.list
apt-get update -y

# Install Kubernetes
echo "[TASK 7] Install Kubernetes kubeadm, kubelet and kubectl"
apt-get install -y kubelet kubeadm kubectl

# Start and Enable kubelet service
echo "[TASK 8] Enable and start kubelet service"
systemctl enable kubelet >/dev/null 2>&1
systemctl start kubelet >/dev/null 2>&1

# Enable ssh password authentication
echo "[TASK 9] Enable ssh password authentication"
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart sshd

# Set Root password
echo "[TASK 10] Set root password"
echo -e "kubeadmin\nkubeadmin" | passwd root

# Update vagrant user's bashrc file
echo "export TERM=xterm" >> /etc/bashrc

