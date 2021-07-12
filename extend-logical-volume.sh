# --- Extend a logical volume 

# 1. Determine available free extends
sudo vgdisplay vg1
# 2. check current file system size
df -h /data
# 3. Extend logical volume upto 8 extents 
# lvextend -­l 8 /dev/vg1/data
# lvextend ­-L +128M /dev/vg1/data 
sudo lvextend -l +3 /dev/vg1/data
df -h /data
# resize file system 
sudo resize2fs /dev/vg1/data
df -h /data
