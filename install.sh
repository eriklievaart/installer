#!/bin/sh
set -e                    # fail on errors
sh -n install.sh          # check this file for syntax errors before executing it


if [ "$HOME" = "/root" ]; then
	die "do not run script as root!"
fi

if [ "$(id -u)" = "0" ]; then
	die "do not run script as root!"
fi


STAMP_START=$(date +%s)
HOME=~
LOG_DIR=/tmp/installer
LOG_FILE=$LOG_DIR/installer_$(date +%y-%m-%d_%T).log
UP_TO_DATE=false

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




if [ ! -f ~/.gitconfig ]
then
	echo "enter git username"
	read git_user
	echo "enter git email"
	read git_email
fi

sudo sh as-root.sh

if [ ! -f ~/.gitconfig ]
then
	git config --global user.name "$git_user"
	git config --global user.email "$git_email"
	git config --global credential.helper cache
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









# install my own scripts
if [ ! -d ~/bin ]; then
	mkdir ~/bin
fi

if [ -d bin ]; then
	echo ""
	echo "copying scripts in bin"
	cp -nr bin/* ~/bin
	chmod +x ~/bin/*
fi

fetch_url $CHECKSTYLE_CACHE  $CHECKSTYLE_URL  $CHECKSTYLE_DESTINATION
fetch_url $ANT_JUNIT_CACHE   $ANT_JUNIT_URL   $ANT_JUNIT_DESTINATION

log "installing eclipse"
sh eclipse-minimal.sh >> $LOG_FILE


cd projects
sh projects.sh


STAMP_END=$(date +%s)
spent=$(expr $STAMP_END - $STAMP_START)
echo "total time spent = $spent seconds"

