# --- setSUID
# 
# two terminals used as student and root

# 1s. view permission of passwd program
stat /usr/bin/passwd
# permissions are 4755/-rwsr-xr-x
# 2s. keep running passwd
passwd
# 2r. check running process
ps aux | grep passwd 
# observation: passwd running as root
# 3s. change password
423ymsM
# SUID allowed user to change password
# 4r. remove SUID bit from passwd command
chmod u-s /usr/bin/passwd
stat /usr/bin/passwd
# permissions are 0755/-rwxr-xr-x
# 5s. run passwd
passwd
# 5r. check program 
ps aux | grep passwd
# observation 
# 6s. change passwd
O3k19V8
# Without SUID no password change
# 7r. Add SUID bit for the passwd program 
chmod u+s /usr/bin/passwd
stat /usr/bin/passwd
# permissions are 
# 8r. reset the password of student
passwd student

# optional 
# All programs with root priviledge
find / perm /4000

# --- Identifying SUID unset programs
# 1. remove SUID from passwd
chmod u-x /usr/bin/passwd
# 2. check 
stat /usr/bin/passwd
# 4655/-rwSr-xr-x
# 3. reset
chmod u+x /usr/bin/passwd
