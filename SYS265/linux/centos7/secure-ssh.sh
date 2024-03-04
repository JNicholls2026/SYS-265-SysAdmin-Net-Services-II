#secure-ssh.sh
#author JNicholls2026
#creates a new ssh user using $1 parameter
#adds a public key from the local repo or curled from the remote repo
#removes roots ability to ssh in

#Creates a user
sudo useradd -m -d /home/${1} -s /bin/bash ${1}
sudo mkdir /home/${1}/.ssh

#adds public key
cd /home/james-loc/SYS-265-SysAdmin-Net-Services-II
sudo cp SYS265/linux/public-keys/id_rsa.pub /home/${1}/.ssh/authorized_keys
sudo chmod 700 /home/${1}/.ssh
sudo chmod 600 /home/${1}/.ssh/authorized_keys
sudo chown -R ${1}:${1} /home/${1}/.ssh

#Block root ssh login
if grep -q "^PermitRootLogin" /etc/ssh/sshd_config; then
	sudo sed -i 's/^PermitRootLogin,*/PermitRootLogin no/' /etc/ssh/sshd_config
else
	echo "PermitRootLogin was not found"
fi

#Restart SSH Service
sudo systemctl restart sshd.service
