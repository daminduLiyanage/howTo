# --- Creating partitions
# 1. fdisk
fdisk /dev/sdb 
# 2. menu
m
# 3. new partition
n
# 4. extended partition
e   
ENTER
ENTER
# 5.To observe the current partition entries type.
p
# 6. create logical partition   
n
ENTER
+256M                                          
# 7. view 
p
# 8. save
w
# 9. check awareness
cat /proc/partitions
# 10. update kernel
partx -a /dev/sdb
cat /proc/partitions 
# 11. format
mkfs.ext3 /dev/sdb5 
# 12. mount point  
mkdir /data 
# 13. find UUID
blkid /dev/vda5
# 14. edit 
vi /etc/fstab UUID=<UUID> /data ext3 defaults 1 2 
# 15.Update the fstab 
mount ­a 
# 16.Observe:    
mount -a
df ­h     
# You will see that new file system is mounted. 

# optional 
# sudo umount <device|directory>
umount /dev/sdb
# check mounted 
# cat /proc/mounts | grep sdb
# mount -t ext4
lsblk -f
# check mount 
lsblk /dev/sdb5
findmnt /dev/sdb5
# partitions not mounted
fdisk -l
# finding mount point
# findmnt <device|mountpoint>
findmnt /dev/sdb5
