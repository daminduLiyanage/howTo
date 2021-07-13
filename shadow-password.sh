# --- Shadow passwords
# format of password hash $id$salt$encrypted

# 1. current password hash of the root user 
sudo grep worker /etc/shadow
# worker:$6$vWuEv8ycKRsDHAoN$5OQVoUF8L\0s6FPHRlvvVbj9qYF.hu.4Ig0I7gUyxu\6QKN2Fz9nJMoid5LCtPBk3Jfmtl6rURoqU.hWV1plG.:18813:0:99999:7::
# $6 is Sha512
# 2. Manualy generating the hash 
perl -e 'print crypt("1234", "\$6\$vWuEv8ycKRsDHAoN"), "\n"'
