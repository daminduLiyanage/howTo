# --- Package Integrity

# default directory /etc/pki/rpm-gpg

# 1. import Red Hat release GPG key 
rpm --import /etc/pki/rpm-gpg/RPM-GPG-Key-RedHat-release
rpm --import RPM-GPG-KEY-redhat-release

# 2. installing from centOS repo
rpm --import https://centos.org/keys/RPM-GPG-KEY-CentOS-Testing

# 3. list imported keys
rpm -qa gpg-pubkey*

# 4. key info 
rpm -qi gpg-pubkey-5ba5fa8d-5ccc6012

# 5. delete a key
rpm -e gpg-pubkey-5ba5fa8d-5ccc6012
