# --- sticky bit
# find / -type f -perm /1000
# find / -type d -perm /1000

# 1. delete file as another user
su - max
cd /redfiles
rm boby1
exit
# 2. to prevent files created by other users
# set to directory not to file
chmod o+t /redfiles
# chmod o-t /redfiles
stat /redfiles
# Access: (3775/drwxrwsr-t)  Uid: (    0/    root)   Gid: (10016/  redhat)
# 3. try deleting as another user
su - bob
touch /redfiles/boby2
exit
su - max
cd /redfiles
rm boby2
# fail
# o+t = --- --t will allow only creator to delete file
exit
# 4. try deleting as the user
su - bob
cd /redfiles
rm boby2
exit
