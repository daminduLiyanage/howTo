

sudo yum install epel-release
sudo yum groupinstall "X Window system"
sudo yum groupinstall xfce
sudo systemctl set-default graphical.target 
rm '/etc/systemd/system/default.target' 
ln -s '/usr/lib/systemd/system/graphical.target' '/etc/systemd/system/default.target'

# web browser 
# on terminal in xfce
sudo yum install epel-release
sudo yum install snapd
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
systemctl status snapd.service
systemctl start snapd
sudo snap install midori

reboot
# should be in applications
