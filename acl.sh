# --- setSUID
# 
# two terminals used as student and root

# 1s. view permission of passwd program
stat /usr/bin/passwd
# permissions are 4755/-rwsr-xr-x
# 2s. keep running passwd
passwd
# 2r. check running process
ps aux | grep passwd 
# observation: passwd running as root
# 3s. change password
423ymsM
# SUID allowed user to change password
# 4r. remove SUID bit from passwd command
chmod u-s /usr/bin/passwd
stat /usr/bin/passwd
# permissions are 0755/-rwxr-xr-x
# 5s. run passwd
passwd
# 5r. check program 
ps aux | grep passwd
# observation 
# 6s. change passwd
O3k19V8
# Without SUID no password change
# 7r. Add SUID bit for the passwd program 
chmod u+s /usr/bin/passwd
stat /usr/bin/passwd
# permissions are 
# 8r. reset the password of student
passwd student

# optional 
# All programs with root priviledge
find / ­perm /4000

# --- Identifying SUID unset programs
# 1. remove SUID from passwd
chmod u-x /usr/bin/passwd
# 2. check 
stat /usr/bin/passwd
# 4655/-rwSr-xr-x
# 3. reset
chmod u+x /usr/bin/passwd


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

# --- sticky bit
# find / -type f -perm /1000
# find / -type d -perm /1000

# 1. delete file as another user
su - max
cd /redfiles
rm boby1
exit
# 2. to prevent files created by other users
# set to directory not to file
chmod o+t /redfiles
# chmod o-t /redfiles
stat /redfiles
# Access: (3775/drwxrwsr-t)  Uid: (    0/    root)   Gid: (10016/  redhat)
# 3. try deleting as another user
su - max
cd /redfiles
rm boby2
# stat /redfiles
# boby2 owned by group 
# but o+t doesn't permit delete even in shared folder
exit
# 4. try deleting as the user
su - bob
cd /redfiles
rm boby2
exit

# --- umask
# system wide /etc/bashrc or /etc/profile
# user-wide ~/.bashrc or ~/.bash_profile
# simply subtract the umask from the base
# permissions to determine the final permission 
# for file as follows for example umask 022
# 666 ­- 022 = 644

# --- File system ACL

# 1. login as root

# 2. create two logical volumes
fdisk /dev/sdb
# extent partition (EP)
n
e
ENTER
ENTER
ENTER
# logical partition (LP)
n
l
ENTER 
+256M
# save
w
# logical volumes (LV)
pvcreate /dev/sdb5
pvcreate /dev/sdb6
pvcreate /dev/sdb7

vgcreate -s 32M vg1 /dev/sdb5 # create group
vgextend vg1 /dev/sdb6 # add
vgextend vg1 /dev/sdb7
lsblk -f

lvcreate -n class --size 256M vg1
lvcreate -n web --size 256M vg1
lsblk -f
# format and mount as /class and /web
mkfs.ext4 /dev/vg1/class
tune2fs -o user_xattr,acl /dev/vg1/class
mkfs.ext4 /dev/vg1/web
mkdir /{class,web}

vi /etc/fstab # mount point
/dev/vg1/class /class ext4 defaults 1 2
/dev/vg1/web /web ext4 defaults,acl 1 2
mount -a
df -h
mount

# 3. create users
useradd bob ; echo "bob:redhat" | chpasswd
useradd cindy ; echo "cindy:redhat" | chpasswd

# 4. create group
groupadd webmaster

# 5. check ACL
getfacl /class
# getfacl: Removing leading '/' from absolute path names
# # file: class
# # owner: root
# # group: root
# user::rwx
# group::r-x
# other::r-x

# 6. create a file
touch /class/myfile
getfacl /class/myfile
# getfacl: Removing leading '/' from absolute path names
# # file: class/myfile
# # owner: root
# # group: root
# user::rw-
# group::r--
# other::r--

# 7. set r & w FACL to user
setfacl -m u:bob:rw /class/myfile
getfacl /class/myfile
# getfacl: Removing leading '/' from absolute path names
# # file: class/myfile
# # owner: root
# # group: root
# # user::rw-
# user:bob:rw-
# group::r--
# mask::rw-
# other::r--

# 8. set r FACL to group
setfacl -m g:webmaster:r /class/myfile
getfacl /class/myfile
# getfacl: Removing leading '/' from absolute path names
# # file: class/myfile
# # owner: root
# # group: root
# user::rw-
# user:bob:rw-
# group::r--
# group:webmaster:r--
# mask::rw-
# other::r--
# 9. log as bob
su - bob
echo Linux > /class/myfile
cat /class/myfile
exit

# 10. change ACL
chmod 622 /class/myfile
getfacl /class/myfile
# getfacl: Removing leading '/' from absolute path names
# # file: class/myfile
# # owner: root
# # group: root
# user::rw-
# user:bob:rw-                    #effective:-w-
# group::r--                      #effective:---
# group:webmaster:r--             #effective:---
# mask::-w-
# other::-w-

# 11. try reading as bob
su - bob
echo RedHat >> /class/myfile
cat /class/myfile # denies 
ls -l /class/myfile # -rw--w--w-+ 1 root root 13 Jul 14 09:40 /class/myfile
exit
cat /class/myfile

# 12. change ACL
setfacl -m u:bob:rw /class/myfile

# 13. check 
getfacl /class/myfile
# getfacl: Removing leading '/' from absolute path names
# # file: class/myfile
# # owner: root
# # group: root
# user::rw-
# user:bob:rw-
# group::r--
# group:webmaster:r--
# mask::rw-
# other::-w-

# 14. add user to group
usermod -aG webmaster cindy
usermod -aG webmaster bob

# 15. FACL r w x for webmaster group
setfacl -m g:webmaster:rwx /web

# 16. set default ACL 
setfacl -m d:g:webmaster:rwx /web

# 17. as cindy
su - cindy
cd /web
mkdir mysite
echo Linux > mysite/index.html
exit

# 18. as bob
su - bob
cd /web
mkdir mysite/private
echo RedHat >> mysite/index.html
getfacl mysite/index.html
# # file: mysite/index.html
# # owner: cindy
# # group: cindy
# user::rw-
# group::r-x                      #effective:r--
# group:webmaster:rwx             #effective:rw-
# mask::rw-
# other::r--
exit

# 19. as root
mkdir /site
setfacl -m g:webmaster:rwx /site

su - cindy
mkdir /site/www
echo RedHat > /site/www/index.html
exit

su - bob
cd /site
mkdir www/private # denies
getfacl www
# # file: www
# # owner: cindy
# # group: cindy
# user::rwx
# group::rwx
# other::r-x
exit
