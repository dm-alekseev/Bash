#!/bin/bash
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config.d/*;
sudo systemctl restart sshd;
#Debian
#grep -rl -w "^PasswordAuthentication yes" /etc/ssh/sshd_config.d/
