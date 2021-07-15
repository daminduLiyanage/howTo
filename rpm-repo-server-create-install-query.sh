# --- Frontend for RPM (HTTP Repo Server)


# Part I - Creating

# 1. intall webserver
yum install -y httpd

# 2. enable httpd at boot
chkconfig httpd on

# 3. create repo dir
mkdir /var/www/html/myrepo

# 4. download few rpms
cd /var/www/html/myrepo
wget -c https://download-ib01.fedoraproject.org/pub/epel/8/Everything/x86_64/Packages/n/ntfs-3g-2017.3.23-11.el8.x86_64.rpm
wget -c http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/php-7.4.6-4.module_el8.3.0+434+2ab5050a.x86_64.rpm
wget -c http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/vsftpd-3.0.3-33.el8.x86_64.rpm
wget -c http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/ftp-0.17-78.el8.x86_64.rpm
ls /var/www/html/myrepo

# 5. install createrepo
yum install -y createrepo

# 6. createrepo base
createrepo -v /var/www/html/myrepo

# 7. update web server
service httpd restart

# 8. check 
cd /var/www/html/myrepo
ls
cd repodata
ls
zless *primary.xml.gz # dependecy db

# 9. .repo yum client config
cd /etc/yum.repos.d
vi myrepo.repo
# add
[myrepo]
name=My Custom Packages
baseurl=file:///var/www/html/myrepo
gpgcheck=0
# myrepo is repo id

# 10. test
yum repolist
yum search ntfs


# Part II - Querying

# 1. search package
yum search php

# 2. list available packages
yum list available

# 3. list already installed 
yum list installed

# 4. info of package
yum info httpd

# 5. list packages for installed
yum provides /etc/passwd

# 6. list package groups
yum grouplist

# 7. list repos
yum repolist


# Part III - Installing

# 1. install individual packages
yum install php

# 2. install without GPG 
yum install php --nogpgcheck

# 3. reinstall package
yum reinstall php

# 4. install package group
yum grouplist | grep -i card # -i ignore case
yum groupinfo "Smart Card Support"
yum groupinstall "Smart Card Support"

# 5. to install multiple packages
yum install php ftp vsftpd

# 6. intall package files from local folder
cd /var/www/html/myrepo
yum localinstall ntfs-3g-2017.3.23-11.el8.x86_64.rpm 
