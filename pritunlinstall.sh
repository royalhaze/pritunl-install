#!/bin/bash

#update repo silent
echo "update repository"
sudo apt-get -qq update >> /dev/null
sleep 2
clear
#install figlet
sudo apt-get -qq install figlet -y >> /dev/null
sudo apt-get -qq install zip unzip autossh tmux python3 -y >> /dev/null
sleep 2
clear
#install pritunl
figlet "install Pritunl on ubuntu 20.04"
sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list << EOF
deb https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse
EOF
sleep 2
clear

figlet "install Pritunl on ubuntu 20.04"
sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb http://repo.pritunl.com/stable/apt focal main
EOF

sudo apt --assume-yes install gnupg
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A
gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A | sudo tee /etc/apt/trusted.gpg.d/pritunl.asc
sudo apt update
sleep 2
clear

figlet "install Pritunl on ubuntu 20.04"
sudo apt-get --assume-yes install gnupg >> /dev/null
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
sleep 2
clear

figlet "install Pritunl on ubuntu 20.04"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
sleep 2
clear

figlet "install Pritunl on ubuntu 20.04"
figlet "update repository"
sudo apt-get -qq update >> /dev/null
sleep 2
clear

figlet "install Pritunl on ubuntu 20.04"
figlet "install database and pritunl"
sudo apt-get --assume-yes -qq install pritunl mongodb-org >> /dev/null
sleep 2
clear

figlet "install Pritunl on ubuntu 20.04"
figlet "run database and pritunl"
sudo systemctl start pritunl mongod 
sleep 2
clear

figlet "install Pritunl on ubuntu 20.04"
figlet "add to startup"
sudo systemctl enable pritunl mongod
sleep 2
clear

#mkdir on temp
mkdir -p /tmp/pritunlinstall /tmp/pihole-dns 
cp -r ./pihole-dns /tmp/pihole-dns 
cp ./piholeinstall.sh /tmp/pihole-dns/piholeinstall.sh 
cd /tmp

#Downgrade Pritunl
figlet "Downgrade Pritunl to 1.30.3108.50"
wget https://github.com/pritunl/pritunl/releases/download/1.32.3457.59/pritunl_1.32.3457.59-0ubuntu1.focal_amd64.deb
dpkg -i pritunl_1.32.3457.59-0ubuntu1.focal_amd64.deb
service pritunl restart
#change ui
figlet "update web interface"
cd /tmp/pritunlinstall
git clone https://github.com/royalhaze/pritunl-ui.git ui
cd ui
chmod +x update.sh
sudo bash update.sh 

#carck pritunl
figlet "carck pritunl"
cd /tmp/pritunlinstall
apt-get -qq install dialog -y >> /dev/null
mkdir pritunlfakeapi
cd pritunlfakeapi
## for old version
#wget https://github.com/samsesh/Pritunl-Fake-API/raw/master/server/setup.sh
#chmod +x setup.sh
#sudo bash setup.sh
wget https://raw.githubusercontent.com/samsesh/Pritunl-Fake-API/master/server/setup.py
chmod +x setup.py
sudo python3 setup.py --install
service pritunl restart
service mongod restart

#######
figlet "your pritunl setup key"
pritunl setup-key
echo "you can active your pritunl"
echo "licens key : active ultimate"
echo "for close installtion break whit use ctrl + c"
sleep 360

