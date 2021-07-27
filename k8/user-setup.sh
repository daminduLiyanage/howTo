sudo mkhomedir_helper c1-cp1
ls -al /home/c1-cp1
# or delete and add 
sudo useradd -m -d /home/control control
hostnamectl set-hostname name
# add to .bashrc in user home 
export PS1="\[\033[38;5;5m\]\u@\[$(tput sgr0)\]\[\033[38;5;2m\]\h\[$(tput sgr0)\] \w\\$ \[$(tput sgr0)\]"
usermod -G wheel control
usermod -G wheel c1-cp1
su control -
cd
