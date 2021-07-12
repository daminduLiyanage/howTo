# --- Create Extended Partion & Logical Partition
# 1. Create extended partition 
sudo fdisk -l
# launch fdisk for correct freespace 
sudo fdisk -u /dev/sdb
# type m then n then e then ENTER then ENTER then ENTER
# check current partition with p. 
# 2. Create the logical partition 
# type n then ENTER type +256M
# 3. Save type w
# Check current running partition 
cat /proc/partitions
# 4. Update running partition 
partx -a /dev/sdb
# 5. Format
mkfs.ext3 /dev/sdb5

# --- Mounting file system. 
#1. create mount point 
mkdir /data
#2. Get UUID
sudo blkid /dev/sdb5
#/dev/sdb5: UUID="88b3af2e-fb44-4826-aec6-3a97c1aad5aa" SEC_TYPE="ext2" TYPE="ext3" PARTUUID="57cc46bc-05"
# 3. add entry to fstab
sudo vi /etc/fstab
# add entry
UUID="88b3af2e-fb44-4826-aec6-3a97c1aad5aa" /data ext3 defaults 1 2 
sudo mount -a
df -h
