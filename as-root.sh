#!/bin/sh
set -e                    # fail on errors
sh -n as-root.sh          # check this file for syntax errors before executing it


JAVA_PKG="openjdk-8-jdk"
JAVA_VERSION="1.8"


die() {
    echo >&2 "Error: $@"
    exit 1
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
		set +e
		sudo apt-get update
		set -e
		UP_TO_DATE=true
	fi
}

install() {
	if (!(dpkg -s $1 | grep "Status: install" )) > /dev/null
	then
		update_once
		echo "Installing $1."
		sudo apt-get -y install $1
		check_status $?
	else
		echo "$1 is already installed"
	fi
}

# enable firewall
sudo ufw enable 
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


# enable ctrl alt f1-f6 terminals
if [ ! -z "$(sudo grep '# *GRUB_TERMINAL' /etc/default/grub)" ]; then
	# backup original grub config (only the first time run)
	sudo cp -n /etc/default/grub /etc/default/grub.original
	sudo sed -i s/#[[:space:]]*GRUB_TERMINAL/GRUB_TERMINAL/ /etc/default/grub
	sudo update-grub
fi


# install default software
install gedit
install vim-gnome
install jedit
install kdiff3

install git
install git-gui
install $JAVA_PKG
install python3
install ant

install pal
install par2
install unrar
install ssh
install tree
install curl
install jq

install mplayer
install xine-ui
install vlc
install kaffeine

install gnome-terminal
install numlockx
install gparted
install filelight
install filezilla
install sabnzbdplus
install synaptic
install partimage
install virtualbox-qt
install android-tools-fastboot


# smoke tests
if (! java -version 2>&1 | grep "version" | grep $JAVA_VERSION)
then
	echo "expecting java $JAVA_VERSION"
fi

