# --- Creating a Volume group and a logical volume 

# 1. Create a partition 
# 2. Convert partion into a physical volume
sudo pvcreate /dev/sdb5
# 3. Create a new volume group with PE size 32MB 
sudo vgcreate -s 32M vg1 /dev/sdb5
# 4. create a logical volume of the size 4 extents (4*32MB in size) with the name "data" 
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
