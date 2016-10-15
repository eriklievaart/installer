```
#!shell
# install git
sudo apt-get install -y git

# download install script
sudo mkdir /opt/zelfgemaakt
cd !$
sudo chmod a+rw !$
git clone https://bitbucket.org/Lievaart/installer.git

# run install script
cd installer
sudo sh install.sh
shutdown -r now


```