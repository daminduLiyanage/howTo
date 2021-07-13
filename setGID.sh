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
chmod g+rwx /redfiles
# 6. create file in shared folder
su - bob
cd /redfiles
touch boby1
stat boby1
# Access: (0664/-rw-rw-r--)  Uid: (10014/     bob)   Gid: (10017/     bob)
exit
# group of this file is bob (private)
# 7. set SGID permission
chmod g+s /redfiles
stat /redfiles
# 2 for g not 4
# 2775/drwxrwsr-x
# 8. create a file in 
su - bob 
cd /redfiles
touch boby2
stat boby2
# Access: (0664/-rw-rw-r--)  Uid: (10014/     bob)   Gid: (10016/  redhat)
exit
