git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:daminduLiyanage/hydroponic-ai.git
git push -u origin main

touch .gitignore
cat .gitignore < code/


ssh-keygen -t rsa -b 4096 -C "damindu7@gmail.com"

eval "$(ssh-agent -s)"
ssh-add -k /home/worker/.ssh/id_rsa


#linux time zone change
timedatectl list-timezones
sudo timedatectl set-timezone Asia/Colombo


ls -al ~/.ssh
ssh-add ~/.ssh/id_rsa

ssh-add -l # list keys added to ssh-add

# windows git bash 
# make user/.ssh folder
ssh-keygen -t ed25519 -C "your_email@example.com" # check defender protection history for ssh-keygen.exe
eval "$(ssh-agent -s)" # output pid 
ssh-add /c/Users/Admin/Documents/.ssh/id_rsa # private key




