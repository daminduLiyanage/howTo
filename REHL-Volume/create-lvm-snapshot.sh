# --- Creating LVM snapshots

# 1. create bigfile in original volume
sudo dd if=/dev/zero of=/data/bigfile bs=1M count=50
ls -l /data
sudo du -h /data
# 2. create snapshot 
# we specify 20M but snapshot size 32M as our PE size 32M
sudo lvcreate -s -n datasnap -L 20M /dev/vg1/data
# 3. mount point 
sudo mkdir /datasnap
sudo mount /dev/vg1/datasnap /datasnap
ls -l /datasnap
df -h
# datasnap has original data
# 4. overwrite bigfile with new data
sudo dd if=/dev/zero of=/data/bigfile bs=1M count=70
# 5. datasnapshot inaccessible (bigfile = 50M but snapshot only 32M)
ls -l /datasnap
# 6. remove snapshot since not usable 
sudo lvremove /dev/vg1/datasnap
# 7. create snapshot and mount
sudo lvcreate -s -n datasnap -L 20M /dev/vg1/data
sudo mount /dev/vg1/datasnap /datasnap
# 8. change data in original volume
sudo echo "User database" >> /data/passwd
tail /data/passwd
tail /datasnap/passwd
# observe changes not propogated to /datasnap/passwd
# 9. merge snapshot with original volume 
# unmount both Lvs
sudo umount /data
sudo umount /datasnap
sudo lvconvert --merge vg1/datasnap
# 10. mount
sudo mount /dev/vg1/data /data
tail /data/passwd
lvs
# observe previous modifications had rollback and snapshot has been removed
