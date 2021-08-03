# Jenkins
# Installing to GUI system

# JDK
sudo yum update -y
sudo yum -y install java-11-openjdk-devel
java --version
# yum install java-1.8.0-openjdk -y
# echo "JAVA_HOME=/usr/bin" >> /root/.bash_profile
# echo "export JAVA_HOME" >> /root/.bash_profile
# JAVA_HOME=/usr/bin
# export JAVA_HOME



# Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade
sudo yum install jenkins java-11-openjdk-devel
sudo systemctl daemon-reload
sudo systemctl start jenkins
sudo systemctl status jenkins


# port 8080
# sudo firewall-cmd --add-port=6443/tcp --permanent
sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
sudo firewall-cmd --reload
 
# check 
grep version /var/lib/jenkins/config.xml
# try
http://localhost:8080

# Jenkins pw
sudo vi /var/lib/jenkins/secrets/initialAdminPassword

# Install git 
su control -
sudo yum update -y
sudo yum install git

kubectl get pods 

# if failing 
kubectl get events --watch

# test
kubectl create deployment first-deployment --image=katacoda/docker-http-server
# failed hello world 
kubectl describe node node1
kubectl get node
journalctl -u k3s | grep "invalid capacity"

# checking memory
free -m
cat /proc/meminfogne