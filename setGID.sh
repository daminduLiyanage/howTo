# --- setGID
# for files
# find / -type f -perm /2000
# for directories
# find / -type d -perm /2000

# 1. create a group
groupadd redhat
# 2. create some users
useradd bob ; echo "bob:redhat" | chpasswd
useradd max ; echo "max:redhat" | chpasswd
# 3. add users to group
usermod -aG redhat bob
usermod -aG redhat max
grep redhat /etc/group
# 4. create directory
mkdir /redfiles
# 5. set group permissions
chgrp redhat /redfiles
chgrp redhat /redfiles
# 6. create file in shared folder
su - bob
cd /redfiles
touch boby1
stat boby1
exit
# group of this file is bob (private)
# 7. set SGID permission
chmod g+s /redfiles
stat /redfiles
# 8. create a file in 
su - bob 
cd /redfiles
touch boby2
stat boby2
exit
