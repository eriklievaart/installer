#!/bin/sh


set -e                    # fail on errors
sh -n install.sh          # check this file for syntax errors before executing it

HOME=~
LOGFILE=/var/log/installer_$(date +%y-%m-%d_%T).log
UP_TO_DATE=false
JAVA_PKG="openjdk-8-jdk"
JAVA_VERSION="1.8"


die() {
    echo >&2 "Error: $@"
    exit 1
}

log() { 
	echo $1
	echo $1 >> $LOGFILE
}

check_status() {
	if [ $1 -ne 0 ]
	then
		die "Installation aborted with status $1"
	fi
}

update_once() {
	if [ $UP_TO_DATE ]
	then
		apt-get update
		check_status $?
		UP_TO_DATE=true
	fi
}

install() {
	if (!(dpkg -s $1 | grep "Status: install" )) > /dev/null
	then
		update_once
		log "Installing $1."
		apt-get -y install $1
		check_status $?
	else
		log "$1 is already installed"
	fi
}

if [ "$(id -u)" = "0" ]; then
	echo "running with root priviliges"
else
	echo "usage: sudo sh install.sh"
	die "This script must be run with root priviliges"
fi

if [ "$HOME" = "/root" ]; then
	echo "usage: sudo sh install.sh"
	die "run script with root priviliges, not as root user"
fi


sudo ufw enable # enable firewall
echo ""


if ! (dpkg -s $JAVA_PKG < /dev/null | grep "Status: install" )
then
	# remove older java versions
	sudo apt-get remove -y openjdk* 
	sudo apt-get autoremove
	sudo apt-get autoclean
	# add apt repository for openjdk
	sudo add-apt-repository -y ppa:openjdk-r/ppa
	update_once
fi




# allow users to invoke shutdown
sudo chmod +s /sbin/shutdown

# backup original grub config (only the first time run)
sudo cp -n /etc/default/grub /etc/default/grub.original

# enable ctrl alt f1-f6 terminals
sudo sed -i s/#[[:space:]]*GRUB_TERMINAL/GRUB_TERMINAL/ /etc/default/grub
sudo update-grub

# install drives
sudo python3 fstab.py




# install default software
install gedit
install vim-gnome
install kdiff3

install pal
install par2
install unrar
install ssh
install tree
install curl

install git
install git-gui
install tortoisehg
install $JAVA_PKG
install python3
install apt-mirror

install mplayer
install xine-ui
install vlc
install kaffeine

install gparted
install filelight
install filezilla
install sabnzbdplus
install synaptic
install partimage
install virtualbox-qt

git config --global user.name "Erik Lievaart"
git config --global user.email "nospam@eriklievaart.com"



# install my own creations
if [ -d ../home ]; then
	cp -nr ../home/* ~ 
fi

if [ -d bin ]; then
	sudo chmod +x bin/*
	# cp -nr bin/* ~/bin
fi

if [ ! -d ~/bin ]; then
	ln -s "$PWD/bin" ~/bin
fi

if [ ! -d /links ]; then
	mkdir /links
	chmod -R a+r /links
	sudo ln -s /media/2000WD/backup/programming/resources/api/ /links/api
fi


echo ""




# smoke tests
if(! java -version 2>&1 | grep "version" | grep $JAVA_VERSION)
then
	echo "expecting java $JAVA_VERSION"
fi


