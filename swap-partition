# --- Creating a Swap Partition

# 1. Create a partition 
# 2. update kernel 
sudo partx -a /dev/sdb
# check 
cat /proc/partitions
# 3. format
sudo mkswap /dev/sdb6
# UUID=e2386bf5-2358-4360-9628-a901fafdfb5d
# 4. use blkid if needed to get UID
sudo vi /etc/fstab
# add
/dev/sdb6 swap swap defaults 0 0
# 5. add to kernel usage
free -m # current usage
sudo swapon -a 
free -m 
