#Setup 
#   1. 4 VMs Ubuntu 18.04, 1 control plane, 3 nodes.
#   2. Static IPs on individual VMs
#   3. /etc/hosts hosts file includes name to IP mappings for VMs
#   4. Swap is disabled
#   5. Take snapshots prior to installation, this way you can install 
#       and revert to snapshot if needed 
#
ssh aen@c1-cp1


#0 - Disable swap, swapoff then edit your fstab removing any entry for swap partitions
#You can recover the space with fdisk. You may want to reboot to ensure your config is ok. 
sudo swapoff -a
sudo nano /etc/fstab

###IMPORTANT####
#I expect this code to change a bit to make the installation process more streamlined.
#Overall, the end result will stay the same...you'll have continerd installed
#I will keep the code in the course downloads up to date with the latest method.
################


#0 - Install Packages 
#containerd prerequisites, first load two modules and configure them to load on boot
#https://kubernetes.io/docs/setup/production-environment/container-runtimes/
sudo modprobe overlay
sudo modprobe br_netfilter
sudo echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF


#Setup required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF


# #Apply sysctl params without reboot
# sudo sysctl --system


# #Install containerd
# sudo apt-get update 
# sudo apt-get install -y containerd

# Install containerd
## Set up the repository
### Install required packages
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

### Add docker repository
exit
usermod -G wheel control
su control -
sudo yum erase podman buildah
# sudo yum install docker-ce
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

## Install containerd
sudo yum update -y 
#&& sudo yum install -y containerd.io
cd
wget -c https://download.docker.com/linux/centos/8/x86_64/test/Packages/containerd.io-1.4.8-3.1.el8.x86_64.rpm
sudo yum localinstall containerd.io-1.4.8-3.1.el8.x86_64.rpm
# Configure containerd
sudo mkdir -p /etc/containerd
sudo containerd config default > /etc/containerd/config.toml

# Restart containerd
systemctl restart containerd


#Create a containerd configuration file
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml


#Set the cgroup driver for containerd to systemd which is required for the kubelet.
#For more information on this config file see:
# https://github.com/containerd/cri/blob/master/docs/config.md and also
# https://github.com/containerd/containerd/blob/master/docs/ops.md

#At the end of this section
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
        ...
#Add these two lines, indentation matters.
          [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
            SystemdCgroup = true

sudo nano /etc/containerd/config.toml


#Restart containerd with the new configuration
sudo systemctl restart containerd




#Install Kubernetes packages - kubeadm, kubelet and kubectl
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF
# Set SELinux in permissive mode (effectively disabling it)
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# Install
VERSION=1.20.1-00
sudo yum install -y kubelet-$VERSION kubeadm-$VERSION kubectl-$VERSION --disableexcludes=kubernetes
sudo systemctl enable --now kubelet


# #Add Google's apt repository gpg key
# curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
# #Add the Kubernetes apt repository
# sudo bash -c 'cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
# deb https://apt.kubernetes.io/ kubernetes-xenial main
# EOF'
# #Update the package list and use apt-cache policy to inspect versions available in the repository
# sudo apt-get update
# apt-cache policy kubelet | head -n 20 
#Install the required packages, if needed we can request a specific version. 
#Use this version because in a later course we will upgrade the cluster to a newer version.
# VERSION=1.20.1-00
# sudo apt-get install -y kubelet=$VERSION kubeadm=$VERSION kubectl=$VERSION
# sudo apt-mark hold kubelet kubeadm kubectl containerd


#To install the latest, omit the version parameters
#sudo apt-get install kubelet kubeadm kubectl
#sudo apt-mark hold kubelet kubeadm kubectl containerd


#1 - systemd Units
#Check the status of our kubelet and our container runtime, containerd.
#The kubelet will enter a crashloop until a cluster is created or the node is joined to an existing cluster.
sudo systemctl status kubelet.service 
sudo systemctl status containerd.service 


#Ensure both are set to start when the system starts up.
sudo systemctl enable kubelet.service
sudo systemctl enable containerd.service
