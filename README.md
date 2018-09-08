```
#!shell
# install git
sudo apt-get install -y git

# download install script
mkdir ~/Development/git
cd !$
sudo chmod a+rw !$
git clone https://github.com/eriklievaart/installer.git

# run install script
cd installer
sh install.sh

```
