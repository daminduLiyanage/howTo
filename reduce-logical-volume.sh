# --- Reduce logical volume 
# Caution: Stop any app using volume

# 1. View current size 
df -h /data
# 2. Backup 
sudo mkdir /var/backup
sudo rsync -aAPvH /data /var/backup
# 3. unmount file system 
sudo umount /data
# 4. check conistancy 
sudo e2fsck -pf /dev/vg1/data
# 5. resize file system
sudo resize2fs /dev/vg1/data 100M
# 6. reduce size of logical volume 
sudo lvreduce -L 100M /dev/vg1/data
# 7. verify
sudo lvdisplay /dev/vg1/data
