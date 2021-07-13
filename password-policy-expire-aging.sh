# --- Password aging 
# (password expiration policy)

# sudo useradd bill
# echo "bill:redhat" | sudo chpasswd

# 1. view password policy
sudo chage -l bill
# 2. expire in 90 days
sudo chage -M 90 bill
sudo grep bill /etc/shadow
# 3. force account to change password in next logic
# -d lastday
sudo grep bill /etc/shadow
sudo chage -d 0 bill
sudo grep bill /etc/shadow
# 4. expire after certain days
EXPDATE=$(date -d "104 days" +%Y-%m-%d)
sudo chage -m 0 -M 90 -W 7 -I 14 -E $EXPDATE bill
# -m min -M max -W warn days -I inactive
sudo grep blara /etc/shadow
# 5. remove account expiration date
sudo chage -E -1 bill
