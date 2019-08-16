#!/bin/sh
set -e                    # fail on errors
sh -n install.sh          # check this file for syntax errors before executing it

# load globals
. ./globals.sh

STAMP_START=$(date +%s)
IBIN_DIR=~/bin
LOG_DIR=/tmp/installer
LOG_FILE=$LOG_DIR/installer_$(date +%y-%m-%d_%T).log
UP_TO_DATE=false
CACHE_DIR=~/.cache

CHECKSTYLE_VERSION=8.11
CHECKSTYLE_DESTINATION=~/Applications/checkstyle/checkstyle.jar
CHECKSTYLE_URL="https://github.com/checkstyle/checkstyle/releases/download/checkstyle-$CHECKSTYLE_VERSION/checkstyle-$CHECKSTYLE_VERSION-all.jar"

ANT_JUNIT_VERSION=1.8.4
ANT_JUNIT_DESTINATION=~/.ant/lib/ant-junit.jar
ANT_JUNIT_URL="https://repo1.maven.org/maven2/org/apache/ant/ant-junit/$ANT_JUNIT_VERSION/ant-junit-$ANT_JUNIT_VERSION.jar"

JUNIT_VERSION=4.7
JUNIT_DESTINATION=~/.ant/lib/junit-$JUNIT_VERSION.jar
JUNIT_URL="https://repo1.maven.org/maven2/junit/junit/$JUNIT_VERSION/junit-$JUNIT_VERSION.jar"

GUICE_VERSION=1.0
GUICE_SRC_JAR_NAME="guice-$GUICE_VERSION-src.jar"
GUICE_SRC_DESTINATION=~/Development/repo/remote/com/google/inject/guice/1.0/$GUICE_SRC_JAR_NAME
GUICE_SRC_URL="http://eriklievaart.com/download?file=guice1src"


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
	destination=$1
	url=$2

	if [ -f ${destination?} ]
	then
		log "already downloaded: ${destination?}"
	else
		sh bin/wgetc ${destination?} $url
	fi
}


# user "root" cannot run this script
if [ "$HOME" = "/root" ]; then
       die "do not run script as root!"
fi



if [ ! -f ~/.gitconfig ]
then
	echo "enter git username"
	read git_user
	echo "enter git email"
	read git_email
	git config --global user.name "$git_user"
	git config --global user.email "$git_email"
	git config --global credential.helper cache
fi

sudo sh as-root.sh




# register shortcuts for window snapping
XFCE_SHORTCUTS_FILE=~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
XFCE_SHORTCUTS_BACKUP="$XFCE_SHORTCUTS_FILE.bak"
xfce_set() {
        key="/xfwm4/custom/$1"
        action="$2"
        xfconf-query --create -c xfce4-keyboard-shortcuts -t string -p "$key" -s "$action" # and set the new binding
}
if [ ! -f "$XFCE_SHORTCUTS_BACKUP" -a -f $XFCE_SHORTCUTS_FILE ]
then
	cp -n "$XFCE_SHORTCUTS_FILE" "$XFCE_SHORTCUTS_BACKUP"
	xfconf-query -c xfce4-keyboard-shortcuts -p "/xfwm4/custom/<Primary><Alt>F10" -r -R # delete maximize binding, it will be relaced
	xfce_set '<Primary><Shift>KP_Begin'     "maximize_window_key"
	xfce_set '<Primary><Shift>KP_Home'      "tile_up_left_key"
	xfce_set '<Primary><Shift>KP_Page_Up'   "tile_up_right_key"
	xfce_set '<Primary><Shift>KP_End'       "tile_down_left_key"
	xfce_set '<Primary><Shift>KP_Page_Down' "tile_down_right_key"
	xfce_set '<Primary><Shift>KP_Left'      "tile_left_key"
	xfce_set '<Primary><Shift>KP_Right'     "tile_right_key"
	xfce_set '<Primary><Shift>KP_Up'        "tile_up_key"
	xfce_set '<Primary><Shift>KP_Down'      "tile_down_key"
	xfce_set '<Primary><Shift>KP_Insert'    "${BIN_DIR?}/move-to-next-monitor"
fi



# install my own scripts
if [ ! -f ~/.profile ]; then
	touch ~/.profile
	chmod +x ~/.profile
fi
if cat ~/.profile | grep -q "/ibin"; then
	echo "ibin already installed"
else
	echo ""
	echo "adding ibin (personal scripts) to path"
	chmod +x ibin/*
	append='PATH=$PATH':"${IBIN?}"
	eval "$append"
	echo "$append" > ~/.profile
	echo
fi

if [ ! -d ~/bin ]; then
	mkdir ~/bin
	PATH=$PATH:~/bin
fi

link_dir=link/home
for file in $(ls -a $link_dir | sed -n '/[.]*[^.].*/p')
do
	location=$PWD/$link_dir/$file
	link=~/$file
	if [ ! -e ${link?} ]; then
		echo "linking ${location?}"
		[ -e ${location?} ] || die "assertion failed $location"
		ln -s "${location?}" "${link?}"
	fi
done

if ! cat ~/.bashrc | grep --quiet 'dirs -v'; then
    echo 'alias dirs="dirs -v"' >> ~/.bashrc
fi

fetch_url ${JUNIT_DESTINATION?} ${JUNIT_URL?}
fetch_url ${ANT_JUNIT_DESTINATION?} ${ANT_JUNIT_URL?}
fetch_url ${GUICE_SRC_DESTINATION?} ${GUICE_SRC_URL?}
fetch_url ${CHECKSTYLE_DESTINATION?} ${CHECKSTYLE_URL?}


log "installing eclipse"
tail -n 0 -f ${LOG_FILE?} &
sh eclipse-minimal.sh >> ${LOG_FILE?}


cd projects
args=$([ "$@" = "" ] && echo "-a" || echo "$@")
sh projects.sh $args


STAMP_END=$(date +%s)
spent=$(expr "$STAMP_END" '-' "$STAMP_START")
echo "total time spent = $spent seconds"



