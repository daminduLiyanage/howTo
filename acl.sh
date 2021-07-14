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
#

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
