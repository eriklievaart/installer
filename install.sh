#!/bin/sh
set -e                    # fail on errors
sh -n install.sh          # check this file for syntax errors before executing it


HOME=~
LOG_DIR=/tmp/installer
LOG_FILE=$LOG_DIR/installer_$(date +%y-%m-%d_%T).log
UP_TO_DATE=false

JAVA_PKG="openjdk-8-jdk"
JAVA_VERSION="1.8"

CHECKSTYLE_VERSION=8.11
CHECKSTYLE_DESTINATION=~/Applications/checkstyle/checkstyle.jar
CHECKSTYLE_CACHE="../cache/checkstyle/checkstyle-$CHECKSTYLE_VERSION.jar"
CHECKSTYLE_URL="https://github.com/checkstyle/checkstyle/releases/download/checkstyle-$CHECKSTYLE_VERSION/checkstyle-$CHECKSTYLE_VERSION-all.jar"

ANT_JUNIT_VERSION=1.8.4
ANT_JUNIT_DESTINATION=~/.ant/lib/ant-junit.jar
ANT_JUNIT_CACHE="../cache/ant-junit/ant-junit-$ANT_JUNIT_VERSION.jar"
ANT_JUNIT_URL="https://repo1.maven.org/maven2/org/apache/ant/ant-junit/$ANT_JUNIT_VERSION/ant-junit-$ANT_JUNIT_VERSION.jar"




die() {
    echo >&2 "Error: $@"
    exit 1
}

log() { 
	if [ ! -d "$LOG_DIR" ]
	then
		mkdir $LOG_DIR
	fi
	echo $1
	echo $1 >> $LOG_FILE
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
		log "Installing $1."
		sudo apt-get -y install $1
		check_status $?
	else
		log "$1 is already installed"
	fi
}

fetch_url() {
	cache_file=$1
	url=$2
	destination=$3

	if [ -f $destination ]
	then
		log "already downloaded: $destination"
	else
		sh bin/wgetc $cache_file $url $destination
	fi
}

if [ "$HOME" = "/root" ]; then
	echo "usage: sudo sh install.sh"
	die "run script with root priviliges (sudo sh install.sh), not as root user"
fi

if [ ! -f ~/.gitconfig ]
then
	echo "enter git username"
	read git_user
	echo "enter git email"
	read git_email

	install git
	git config --global user.name "$git_user"
	git config --global user.email "$git_email"
	git config --global credential.helper cache
fi

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

# register shortcuts for window snapping
XFCE_SHORTCUTS_FILE=~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
XFCE_SHORTCUTS_BACKUP="$XFCE_SHORTCUTS_FILE.bak"
xfce_set() {
        key="/xfwm4/custom/$1"
        action="$2"
        xfconf-query -c xfce4-keyboard-shortcuts -p "$key" -r -R                           # delete previous binding
        xfconf-query --create -c xfce4-keyboard-shortcuts -t string -p "$key" -s "$action" # and set the new binding
}
if [ ! -f "$XFCE_SHORTCUTS_BACKUP" -a -f $XFCE_SHORTCUTS_FILE ]
then
	cp -n "$XFCE_SHORTCUTS_FILE" "$XFCE_SHORTCUTS_BACKUP"
	xfce_set '<Primary><Shift>KP_Begin'     "maximize_window_key"
	xfce_set '<Primary><Shift>KP_Home'      "tile_up_left_key"
	xfce_set '<Primary><Shift>KP_Page_Up'   "tile_up_right_key"
	xfce_set '<Primary><Shift>KP_End'       "tile_down_left_key"
	xfce_set '<Primary><Shift>KP_Page_Down' "tile_down_right_key"
	xfce_set '<Primary><Shift>KP_Left'      "tile_left_key"
	xfce_set '<Primary><Shift>KP_Right'     "tile_right_key"
	xfce_set '<Primary><Shift>KP_Up'        "tile_up_key"
	xfce_set '<Primary><Shift>KP_Down'      "tile_down_key"
fi




# install default software
install gedit
install vim-gnome
install jedit
install kdiff3

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





# install my own scripts
if [ ! -d ~/bin ]; then
	mkdir ~/bin
fi

if [ -d bin ]; then
	echo ""
	echo "copying scripts in bin"
	cp -nr bin/* ~/bin
	sudo chmod +x ~/bin/*
fi

fetch_url $CHECKSTYLE_CACHE  $CHECKSTYLE_URL  $CHECKSTYLE_DESTINATION
fetch_url $ANT_JUNIT_CACHE   $ANT_JUNIT_URL   $ANT_JUNIT_DESTINATION

log "installing eclipse"
sh eclipse-minimal.sh >> $LOG_FILE


# cd projects
# sh projects.sh




# turn on numlock automatically, is this line necessary? Needs testing
# /usr/bin/numlockx on



# smoke tests
if (! java -version 2>&1 | grep "version" | grep $JAVA_VERSION)
then
	echo "expecting java $JAVA_VERSION"
fi



