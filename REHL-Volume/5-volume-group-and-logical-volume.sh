# --- Creating a Volume group and a logical volume 

# 1. Create a partition 
# 2. create physical /dev/sdb7 
sudo pvcreate /dev/sdb7
# 3. create group /dev/vg1/ PE=32M
sudo vgcreate -s 32M vg1 /dev/sdb7
# 4. create /dev/vg1/data
# lvcreate ­n data ­L 100M vg1
sudo lvcreate -n data -l 4 vg1
# to add
# vgextend vg1 /dev/sdb6
# 5. Format
sudo mkfs.ext4 /dev/vg1/data
# 6. Create mount point 
sudo mkdir /data
# 7. edit fstab
sudo vi /etc/fstab
# add
/dev/vg1/data /data ext4 defaults 1 2
# 8. update 
sudo mount -a
df -h
# 9. try creating something
sudo cp /etc/passwd /etc/group /data
sudo lvdisplay

# optional
# 10. to remove LV
# lvremove /dev/group/lvname
lvremove /dev/vg1/data
# 11. removing VG and PV
# make sure unmounted all 
lvremove -f [vg_name]/[lv_name]
# deactivate
vgchange -an [vg_name]
vgremove [vg_name]
pvremove [pv_name]

# udevadm info --query=property  /dev/zero | egrep "DEVNAME|ID_FS_TYPE"