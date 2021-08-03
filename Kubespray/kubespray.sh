Vagrant.configure("2") do |config|
  config.vm.define "amaster" do |amaster|
    amaster.vm.box_download_insecure = true
    amaster.vm.box = "hashicorp/bionic64"
    amaster.vm.network "private_network", ip: "10.0.5.4"
    amaster.vm.hostname = "amaster"
    amaster.vm.provider "virtualbox" do |v|
      v.name = "amaster"
      v.memory = 2048
      v.cpus = 2
    end
  end

  config.vm.define "kmaster" do |kmaster|
    kmaster.vm.box_download_insecure = true
    kmaster.vm.box = "hashicorp/bionic64"
    kmaster.vm.network "private_network", ip: "10.0.5.2"
    kmaster.vm.hostname = "kmaster"
    kmaster.vm.provider "virtualbox" do |v|
      v.name = "kmaster"
      v.memory = 2048
      v.cpus = 2
    end
  end

  config.vm.define "kworker" do |kworker|
    kworker.vm.box_download_insecure = true
    kworker.vm.box = "hashicorp/bionic64"
    kworker.vm.network "private_network", ip: "10.0.5.3"
    kworker.vm.hostname = "kworker"
    kworker.vm.provider "virtualbox" do |v|
      v.name = "kworker"
      v.memory = 2048
      v.cpus = 2
    end
  end

end
# ---

vagrant up
sudo vi /etc/hosts
10.0.5.4 amaster.jhooq.com amaster
10.0.5.2 kmaster.jhooq.com kmaster
10.0.5.3 kworker.jhooq.com kworker

cat /etc/hosts
127.0.0.1	localhost
127.0.1.1	amaster	amaster

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
10.0.5.4 amaster.jhooq.com amaster
10.0.5.2 kmaster.jhooq.com kmaster
10.0.5.3 kworker.jhooq.com kworker


ssh-keygen -t rsa
# Generating public/private rsa key pair.
# Enter file in which to save the key (/home/vagrant/.ssh/id_rsa): 
# Enter passphrase (empty for no passphrase): 
# Enter same passphrase again: 
# Your identification has been saved in /home/vagrant/.ssh/id_rsa.
# Your public key has been saved in /home/vagrant/.ssh/id_rsa.pub.
# The key fingerprint is:
# SHA256:LWGasiSDAqf8eY3pz5swa/nUl2rWc1IFgiPuqFTYsKs vagrant@amaster
# The key's randomart image is:
# +---[RSA 2048]----+
# |          .      |
# |   .   . o . .   |
# |. . = . + . . .  |
# |o+ o o = o     . |
# |+.o = = S .   .  |
# |. .*.++...  ..   |
# |  ooo*.o ..o.    |
# | E .oo* .oo+ .   |
# |    .oo*+.  +    |
# +----[SHA256]-----+

ssh-copy-id 10.0.5.2
ssh-copy-id 10.0.5.3


sudo apt-get update
sudo apt install python3-pip
python -V
# Python 2.7.15+
pip3 -V
# pip 9.0.1 from /usr/lib/python3/dist-packages (python 3.6)


git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray
sudo pip3 install -r requirements.txt

cp -rfp inventory/sample inventory/mycluster
declare -a IPS=(10.0.5.2 10.0.5.3)
CONFIG_FILE=inventory/mycluster/hosts.yml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
cat inventory/mycluster/hosts.yml

ansible-playbook -i inventory/mycluster/hosts.yml --become --become-user=root cluster.yml

vagrant ssh kmaster
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
sudo cp /etc/kubernetes/admin.conf /home/vagrant/config
mkdir .kube
mv config .kube/
sudo chown $(id -u):$(id -g ) $HOME/.kube/config
kubectl version
# Client Version: version.Info{Major:"1", Minor:"18", GitVersion:"v1.18.2", GitCommit:"52c56ce7a8272c798dbc29846288d7cd9fbae032", GitTreeState:"clean", BuildDate:"2020-04-16T11:56:40Z", GoVersion:"go1.13.9", Compiler:"gc", Platform:"linux/amd64"}
# Server Version: version.Info{Major:"1", Minor:"18", GitVersion:"v1.18.2", GitCommit:"52c56ce7a8272c798dbc29846288d7cd9fbae032", GitTreeState:"clean", BuildDate:"2020-04-16T11:48:36Z", GoVersion:"go1.13.9", Compiler:"gc", Platform:"linux/amd64"}


kubectl get nodes
# NAME    STATUS   ROLES    AGE   VERSION
# node1   Ready    master   13m   v1.18.2
# node2   Ready    master   13m   v1.18.2


