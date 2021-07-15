# Extending a Volume Group

# 1. Create a partition
sudo fdisk -l
sudo fdisk -u /dev/sdb
# 2. update kernal 
sudo partx -a /dev/sdb7
cat /proc/partitions
# 3. create a physical volume (in partition created)
sudo pvcreate /dev/sdb7
# 4. extend volume group 
sudo vgextend vg1 /dev/sdb7
# 5. check 
sudo vgdisplay vg1
