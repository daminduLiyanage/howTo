# --- Creating a swap file 

# 1. Create swap file of 512M block size
sudo dd if=/dev/zero of=/var/swapfile bs=1M count=512
du -h /var/swapfile # check 
# 2. format swap file 
sudo mkswap /var/swapfile
# 3. edit fstab 
sudo vi /etc/fstab
/var/swapfile swap swap default 0 0
# 4. add swap to existing swap 
sudo chmod 0600 /var/swapfile
sudo swapon -a
# 5. 
free -m  
