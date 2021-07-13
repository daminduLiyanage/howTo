# --- File system ACL

# 1. login as root
# 2. create two logical volumes
fdisk /dev/sdb
# delete everything
# create extent
n
e
ENTER
ENTER
ENTER
# create logical partitions (LP)
n
l
ENTER 
+256M
# save
w
# create physical volumes from LPs
pvcreate /dev/sdb5
# create a group
vgcreate -s 32M vg1 /dev/sdb5
lsblk -f
lvcreate -n class --size 256M vg1
lsblk -f
# another PV
pvcreate /dev/sdb6
lsblk -f
# add to VG
vgextend vg1 /dev/sdb6
lsblk -f
lvcreate -n web --size 256M vg1
# format and mount as /class and /web

lvcreate -n class --size 256M vg1
mkfs.ext4 /dev/vgsrv/class
tune2fs -o user_xattr,acl /dev/vgsrv/class
lvcreate -n web --size 256M vgsrv
mkfs.ext4 /dev/vgsrv/web
mkdir /{class,web}
# add to /etc/fstab
vi /etc/fstab
/dev/vgsrv/class /class ext4 defaults 1 2
/dev/vgsrv/web /web ext4 defaults,acl 1 2
# update
mount -a
# check
df -h
mount
# 3. create users
useradd bob ; echo "bob:redhat" | chpasswd
useradd cindy ; echo "cindy:redhat" | chpasswd
# 4. create group
groupadd webmaster
# 5. check ACL
getfacl /class
#
# 6. create a file
touch /class/myfile
getfacl /class/myfile
# 
# 7. set r & w FACL to user
setfacl -m u:bob:rw /class/myfile
getfacl /class/myfile
#
# 8. set r FACL to group
setfacl -m g:webmaster:r /class/myfile
getfacl /class/myfile
#
# 9. log as bob
su - bob
echo Linux > /class/myfile
cat /class/myfile
exit
# 10. change ACL
chmod 622 /class/myfile
getfacl /class/myfile
#
# 11. try reading as bob
su - bob
echo RedHat >> /class/myfile
cat /class/myfile
ls -l /class/myfile
exit
cat /class/myfile
#
# 12. change ACL
setfacl -m u:bob:rw /class/myfile
# 13. check 
getfacl /class/myfile
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
mkdir www/private
getfacl www
exit
