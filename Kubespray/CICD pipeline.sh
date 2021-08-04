Vagrant.configure("2") do |config|
  config.vm.define "jenkinsserver" do |jenkinsserver|
    jenkinsserver.vm.box_download_insecure = true
    jenkinsserver.vm.box = "hashicorp/bionic64"
    jenkinsserver.vm.network "forwarded_port", guest: 8080, host: 8080
    jenkinsserver.vm.network "forwarded_port", guest: 8081, host: 8081
    jenkinsserver.vm.network "forwarded_port", guest: 9090, host: 9090
    jenkinsserver.vm.network "private_network", ip: "10.0.5.5"
    jenkinsserver.vm.hostname = "jenkinsserver"
    jenkinsserver.vm.provider "virtualbox" do |v|
      v.name = "jenkinsserver"
      v.memory = 2048
      v.cpus = 2
    end
  end

  config.vm.define "k8smaster" do |k8smaster|
    k8smaster.vm.box_download_insecure = true
    k8smaster.vm.box = "hashicorp/bionic64"
    k8smaster.vm.network "private_network", ip: "10.0.5.2"
    k8smaster.vm.hostname = "k8smaster"
    k8smaster.vm.provider "virtualbox" do |v|
      v.name = "k8smaster"
      v.memory = 2048
      v.cpus = 2
    end
  end


  config.vm.define "k8sworker" do |k8sworker|
    k8sworker.vm.box_download_insecure = true
    k8sworker.vm.box = "hashicorp/bionic64"
    k8sworker.vm.network "private_network", ip: "10.0.5.3"
    k8sworker.vm.hostname = "k8sworker"
    k8sworker.vm.provider "virtualbox" do |v|
      v.name = "k8sworker"
      v.memory = 2048
      v.cpus = 2
    end
  end
end


# ---

vagrant up 
vagrant ssh jenkinsserver
sudo apt update
sudo apt install openjdk-8-jdk
java -version
# openjdk version "1.8.0_265"
# OpenJDK Runtime Environment (build 1.8.0_265-8u265-b01-0ubuntu2~18.04-b01)
# OpenJDK 64-Bit Server VM (build 25.265-b01, mixed mode) 

# install jenkins
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins

# on base computer
http://10.0.5.5:8080/
# jenkins init pw
cat /var/log/jenkins/jenkins.log

# in jenkins select 'install suggested plugins'
# instance configuration ip should be 10.0.5.5

# plugin
# Manage Jenkins -> Manage Plugin -> Available -> SSH Pipeline Steps

# Gradle
# Manage Jenkins -> Global Tool Configuration -> Gradle
# Install Automatically
# Install from Gradle.org 
# Important! Before starting project add Gradle

vagrant ssh jenkinsserver
sudo apt install docker.io
# Client:
#  Version:           19.03.6
#  API version:       1.40
#  Go version:        go1.12.17
#  Git commit:        369ce74a3c
#  Built:             Wed Oct 14 19:00:27 2020
#  OS/Arch:           linux/amd64
#  Experimental:      false 

sudo usermod -aG docker $USER 
sudo usermod -aG docker jenkins 

# Check jenkinsfile 
# add each stage step by step and check builds