# --- setUID
# two terminals used as student and root

# 1s. view permission of passwd program
stat /usr/bin/passwd
# permissions are 
# 2s. keep running passwd
passwd
# 2r. check running process
ps aux | grep passwd 
# observation 
# 3s. change password
423ymsM
# 4r. remove SUID bit from passwd command
chmod u-s /usr/bin/passwd
stat /usr/bin/passwd
# permissions are 
# 5s. run passwd
passwd
# 5r. check program 
ps aux | grep passwd
# observation 
# 6s. change passwd
O3k19V8
# 7r. Add SUID bit for the passwd program 
chmod u+s /usr/bin/passwd
stat /usr/bin/passwd
# permissions are 
# 8r. reset the password of student
passwd student
