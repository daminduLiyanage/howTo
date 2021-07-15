# --- Repo creation with installation media

yum install autofs -y
systemctl start autofs
systemctl status autofs

# 1. create directory
mkdir /var/images

# 2. RHEL6 installation ISO
cd /var/images
touch myTestIso.iso

# 3. mount directory
mkdir /export

# 4. map ISO indirectly
vi /etc/auto.iso
# add
rhel6 -fstype=iso9660,loop :/var/images/myTestIso.iso

# 5. add map to master file
vi /etc/auto.master
# add
/export /etc/auto.iso

# 6. update autofs
service autofs reload

# 7. create repo client
cd /etc/yum.repos.d
vi iso.repo
# add
[isorepo]
name-RHEL6 ISO Image Repository
baseurl=file:///export/rhel6
gpgcheck=1
gpgkey=1
gpgkey=file:///etc/pki/rpm-gpg/RPM­GPG­KEY­redhat­release

# 8. list repos
yum repolist
# check 
df -h 
cat /etc/mtab

# 9. install from iso repo, disable others
yum --disablerepo=* --enablerepo=isorepo install php
