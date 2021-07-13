# --- User administration 
# to control useradd bahaviour edit /etc/login.defs and 
# /etc/default/useradd

# 1. creating user account with defaults
# -n for no priviledge group
# -M for no home directory
useradd bob
passwd bob
grep bob /etc/passwd
grep bob /etc/group

useradd -n -M bony
ls /home
grep bony /etc/passwd
grep bony /etc/group
# 2. Taking password from stdin
useradd mark
echo redhat | passwd --stdin mark
# 3. check 
tail -n2 /etc/passwd
tail -n2 /etc/group
tail -n2 /etc/shadow
# 4. user with GECOS full name
# and a specific UID
useradd -u 10001 -c "Brian Lara" blara
# 5. check 
grep blara /etc/passwd
# 6. root equivalent backdoor account
useradd -rou 0 -g 0 -c "backdoor" -d /root toor
su - toor
id
exit
# 7. Creating a system (service) account with no home directory, 
# no interactive shell and set initial group  membership to an 
# exiting group.
useradd -r -s /sbin/nologin -g sys -G games maxi
grep maxi /etc/passwd
grep maxi /etc/group
# 8. multiple accounts with password
for newaccount in berny gary randy russel agula
do
    useradd $newaccount
    echo redhat | passwd --stdin $newaccount
done
# 10. creating group
groupadd gls
# 11. group with specific ID
groupadd -g 1001 redhat
grep redhat /etc/group
# 12. add users to group
usermod -G gls,redhat russel
grep russel /etc/group
# 13. vipw edits the files /etc/passwd and
# vigr edits /etc/group
sudo vipw
sudo vigr
# 14. move user to a new directory
mkdir /home2
usermod -d 
# 15. renaming account
usermod -l tagula -d /home/tagula -m agula
passwd tagula
# prev password redhat
# 16. edit details as a non-priviledged user
su - tagula
chfn
finger tagula
# 18. Create a folder shared by the group redhat 
# and create some files as user russell
sudo mkdir -p /share/redhat
chgrp redhat /share/redfile
chmod g+rwx /share/redfile
su - russel
cd /share/redfile
touch myfile_{a,b,c,d}
id
exit
# 19. deleting a user account
# option ­r deletes the user's home directory 
# common practice to record the UID of the user prior to deleting
userdel -r russel
find / -uid <UID>
find / -uid <UID> -exec rm {} \; # Delete the files outside of the home directory
# 20. Locking & unlocking
usermod -L tagula
grep tagula /etc/shadow
# !! marks infront of locked account
# usermod --unlock daygeek
usermod -U daygeek
