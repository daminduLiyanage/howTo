# --- User administration 
# to control useradd bahaviour edit /etc/login.defs and 
# /etc/default/useradd

# 1. creating user account with defaults
# -N for no priviledge group
# -M for no home directory
sudo useradd bob
sudo passwd bob
grep bob /etc/passwd
grep bob /etc/group

sudo useradd -N -M bony
ls /home
grep bony /etc/passwd
grep bony /etc/group
# 2. Taking password from stdin
sudo useradd mark
echo redhat | passwd mark --stdin
# echo "mark:redhat" | sudo chpasswd

# Your passwd command may not have a --stdin option: 
# use the chpasswd utility instead, as suggested by 
# 3. check 
tail -n2 /etc/passwd
tail -n2 /etc/group
sudo tail -n2 /etc/shadow
# 4. user with GECOS full name
# and a specific UID
sudo useradd -u 10001 -c "Brian Lara" blara
# 5. check 
grep blara /etc/passwd
# 6. root equivalent backdoor account
sudo useradd -rou 0 -g 0 -c "backdoor" -d /root turr
su - toor
id
exit
# 7. Creating a system (service) account with no home directory, 
# no interactive shell and set initial group  membership to an 
# exiting group.
sudo useradd -r -s /sbin/nologin -g sys -G games maxi
grep maxi /etc/passwd
grep maxi /etc/group
# 8. multiple accounts with password
for newaccount in berny gary randy russel agula
do
    sudo useradd $newaccount
    echo "$newaccount:redhat" | sudo chpasswd
done
# sudo userdel -r tagula
# sudo useradd -r agula
# sudo groupdel agula
# 10. creating group
sudo groupadd gls
# sudo groupdel gls
# 11. group with specific ID
sudo groupadd -g 1002 redhat
grep redhat /etc/group
# 12. add users to group
sudo usermod -G gls,redhat russel
grep russel /etc/group
# 13. vipw edits the files /etc/passwd and
# vigr edits /etc/group
sudo vipw
sudo vigr
# 14. move user to a new directory
# sudo rm -rf /home2
sudo mkdir /home2
sudo usermod -d /home2/bony/ -m bony
# 15. renaming account
sudo usermod -l tagula -d /home/tagula -m agula
sudo passwd tagula
# prev password redhat
# 16. edit details as a non-priviledged user
su - tagula
chfn
finger tagula
# 18. Create a folder shared by the group redhat 
# and create some files as user russell
# sudo rm -rf /share/redfile
sudo mkdir -p /share/redfile
sudo chgrp redhat /share/redfile
sudo chmod g+rwx /share/redfile
su - russel
cd /share/redfile
touch myfile_{a,b,c,d}
id
exit
# 19. deleting a user account
# option ­r deletes the user's home directory 
# common practice to record the UID of the user prior to deleting
sudo userdel -r russel
sudo find / -uid 10012
sudo find / -uid 10012 -exec rm {} \; # Delete the files outside of the home directory
# 20. Locking & unlocking
sudo usermod -L tagula
sudo grep tagula /etc/shadow
# !! marks infront of locked account
# usermod --unlock daygeek
sudo usermod -U tagula

# delete created accounts
for newaccount in berny gary randy russel agula mark blara bob mark maxi turr
do
    sudo userdel -r $newaccount
done
sudo groupdel redhat
