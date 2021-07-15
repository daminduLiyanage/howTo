# --- Installing with RPM

# 1. install from http or ftp
rpm -ivh http://rpmfind.net/linux/opensuse/tumbleweed/repo/oss/x86_64/postfix-3.6.1-3.1.x86_64.rpm
# -i install -v verify -h hash marks progress bar

# 2. reinstalling
rpm -ivh http://rpmfind.net/linux/opensuse/tumbleweed/repo/oss/x86_64/postfix-3.6.1-3.1.x86_64.rpm --replacefiles
# or 
rpm -ivh http://rpmfind.net/linux/opensuse/tumbleweed/repo/oss/x86_64/postfix-3.6.1-3.1.x86_64.rpm --replacepkgs
# or
rpm -ivh http://rpmfind.net/linux/opensuse/tumbleweed/repo/oss/x86_64/postfix-3.6.1-3.1.x86_64.rpm --force

# 3. upgrading
# also install if not exist
rpm -Uvh postfix-3.6.1-3.1.x86_64.rpm
# forcing
rpm -Uvh postfix-3.6.1-3.1.x86_64.rpm --force --nodeps

# 4. removing 
rpm -e postfix
# for dependency complaints
rpm -e postfix --nodeps
