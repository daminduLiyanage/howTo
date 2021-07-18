1. 
2. create logical volumes
fdisk /dev/sdb
pvcreate /dev/sdb5
lsblk -l /dev/sdb
vgcreate -s 32M vgsrv /dev/sdb5
lvcreate -n class --size 256M vgsrv
lvcreate -n web --size 256M vgsrv
mkfs.ext4 /dev/vgsrv/class
mkfs.ext4 /dev/vgsrv/web
# mount ACL
tune2fs -o user_xattr,acl /dev/vgsrv/class
tune2fs -o user_xattr,acl /dev/vgsrv/web
mkdir /{class,web}
echo "/dev/vgsrv/class /class ext4 defaults 1 2" >> /etc/fstab
echo "/dev/vgsrv/web /web ext4 defaults,acl 1 2" >> /etc/fstab
mount -a
mount | grep 'web\|class'
df -h | grep 'web\|class'

# 3. create users
useradd bob ;echo redhat | passwd --stdin bob
useradd cindy ; echo redhat | passwd --stdin cindy

# 4. create group 
groupadd webmaster

# 5. check 
getfacl /class

# 6. create a file
touch /class/myfile # 0644
getfacl /class/myfile

# 7. change FACL
setfacl -m u:bob:rw /class/myfile
getfacl /class/myfile

# 8. FACL for group
setfacl -m g:webmaster:r /class/myfile
getfacl /class/myfile
# groups bob

# 9. check 
su - bob
echo Linux > /class/myfile2 # ok
cat /class/myfile # ok
exit

# 10. 662 to 622
chmod 622 /class/myfile
getfacl /class/myfile
# effective permission as bob's group have no 'w'

# 11.
su - bob
echo RedHatt >> /class/myfile # ok
cat /class/myfile # fail
ls -l /class/myfile
exit
cat /class/myfile

# 12. 
setfacl -m u:bob:rw /class/myfile
# effective permission removed (chmod changed)

# 13. 
getfacl /class/myfile

14. 
usermod -aG webmaster cindy

# to original
setfacl -b /class/myfile
# remove entry
setfacl -x u:bob myfile

# undo
rm /class/myfile

echo 'ok' > myfile ; cat myfile 

# check how ls -l change
setfacl -m u:bob:rw myfile
ls -l myfile
stat myfile | grep Access
setfacl -x u:bob myfile
ls -l myfile
stat myfile | grep Access
