
# --- Querying an RPM Database

# 1. download postfix & httpd
# find architecture $ uname -m 
wget -c http://rpmfind.net/linux/opensuse/tumbleweed/repo/oss/x86_64/postfix-3.6.1-3.1.x86_64.rpm
ls
# 2. list all packages
rpm -qa

# 3. list filter
rpm -qa | grep crond
rpm -qa | grep fox
rpm -qa | grep ldap

# 4. queries
rpm -q postfix
rpm -q crond
rpm -q kernel

# 5. basic info installed packages
rpm -qi postfix
rpm -qi crond 
rpm -qi kernel

# 6. list scripts installed by packages
rpm -q --scripts postfix
#
# list scripts before install 
rpm -qp --scripts postfix-3.6.1-3.1.x86_64.rpm

# 7. list config files
rpm -qc postfix
rpm -qc vsftpd

# 8. list files installed
rpm -qf /etc/passwd
rpm -qf /usr/bin/passwd
# rpm -qf $(which passwd)

# 9. list all files installed
rpm -ql postfix
rpm -ql httpd
rpm -ql crond

# -p
rpm -qlp postfix-3.6.1-3.1.x86_64.rpm
rpm -qip postfix-3.6.1-3.1.x86_64.rpm
rpm -qcp postfix-3.6.1-3.1.x86_64.rpm
