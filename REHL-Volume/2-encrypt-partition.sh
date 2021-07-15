# --- Encrypting a partition 
# 1. update
sudo partx -a /dev/sdb
# 2. prepare
# if necessary unmounted  
sudo umount /data
cryptsetup luksFormat /dev/sdb6 # dfk#gfhs
# 3. Unlock the encryption to create the virtual device under /dev/mapper
sudo cryptsetup luksOpen /dev/sdb6 secret
# 4. check device
ls -l /dev/mapper
# 5. Create an EXT4 file system in the new device
sudo mkfs.ext4 /dev/mapper/secret 
# 6. create mount point 
sudo mkdir /secdata
# 7. mount temporary 
sudo mount /dev/mapper/secret /secdata
# 8. copy some data to check 
sudo cp /etc/passwd /etc/group /secdata
# 9. unmount
sudo umount /secdata 
# check
sudo fdisk -l
# 10. Add an entry for persistently mount the file system
/dev/mapper/secret /secdata ext4 defaults 1 2
reboot
# system stops booting by presenting you a “sulogin” shell
# 11. root filesystem mounted in r, change to r/w
sudo vi /etc/fstab
# comment following
mount -o remount,rw /
# 12. Create an entry for secret
sudo vi /etc/crypttab
# add 
secret /dev/vda6
# 13. Reboot. Passprase is the one given to new partition 
# 14. check 
df -h

# optional 
# 15. generate a key and add it to /etc/crypttab
dd if=/dev/urandom of=/root/seckey bs=4096 count=1
# 16. add entry to /etc/crypttab
sudo vi /etc/crypttab
# add
secret /dev/vda6 /root/seckey
# 17. set permissions 
chmod 400 /root/seckey
# 18. add key to luks 
cryptsetup luksAddKey /dev/vda6 /root/seckey
# 19. reboot and check 
df -h
mount
