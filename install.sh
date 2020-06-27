#!/bin/sh

# usage: ./install    = git pull & install projects
# usage: ./install -a = git pull & install projects
# usage: ./install -i = install projects
# usage: ./install -g = git pull projects
# usage: ./install -s = skip projects

set -e                    # fail on errors
sh -n "$0"                # check this file for syntax errors before executing it

# load globals
. ./globals.sh

STAMP_START=$(date +%s)
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
		sh ${IBIN_DIR?}/wgetc $url ${destination?}
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
	git config pull.rebase true
fi

cd includes
sudo ./as-root.sh
cd -



# firefox settings
if [ -d ~/.mozilla ]; then
	file=$(find ~/.mozilla -name prefs.js)
	append=""
	while read key value
	do 
		[ "$key" = "" ] && continue
		sed -ir "/$key/d" $file
		append="user_pref(\"$key\", $value);\n$append"
	done < config/firefox.txt
	echo -n "$append" >> $file
fi




# install my own scripts
if [ ! -f ~/.profile ]; then
	touch ~/.profile
	chmod +x ~/.profile
fi
if cat ~/.profile | grep -q "/ibin"; then
	echo "ibin already installed"
else
	echo "adding ibin (personal scripts) to path"
	chmod +x ibin/*
	echo "export IBIN=${IBIN_DIR?}" >> ~/.profile
	echo 'PATH=$PATH:~/bin:$IBIN' >> ~/.profile
fi

if [ ! -d ~/bin ]; then
	mkdir ~/bin
	PATH=$PATH:~/bin
fi

sed -i 's/HISTSIZE=.*/HISTSIZE=10000/' ~/.bashrc
sed -i 's/HISTFILESIZE=.*/HISTFILESIZE=20000/' ~/.bashrc

[ -e ~/.config/i3 ] || ln -s $PWD/link/i3 ~/.config/i3
link_dir=link/home
for file in $(ls -a "${link_dir?}" | sed -n '/[.]*[^.].*/p')
do
	location=$PWD/$link_dir/$file
	link=~/$file
	if [ ! -e "${link?}" ]; then
		echo "linking ${location?}"
		[ -e ${location?} ] || die "assertion failed $location"
		ln -s "${location?}" "${link?}"
	fi
done

# vim plugins
mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
cd ~/.vim/bundle
[ -d nerdtree ] || git clone https://github.com/preservim/nerdtree.git
[ -d colorizer ] || git clone https://github.com/lilydjwg/colorizer
[ -d vim-airline ] || git clone https://github.com/vim-airline/vim-airline
[ -d vim-airline-themes ] || git clone https://github.com/vim-airline/vim-airline-themes
cd -

# configure xed text editor
dconf write /org/x/editor/preferences/editor/scheme "'cobalt'"
sed -i 's/mousepad.desktop/xed.desktop/g' ~/.config/mimeapps.list
sed -i '/^text\/plain=/d;$s|$|\ntext/plain=xed.desktop|' ~/.config/mimeapps.list


fetch_url ${JUNIT_DESTINATION?} ${JUNIT_URL?}
fetch_url ${ANT_JUNIT_DESTINATION?} ${ANT_JUNIT_URL?}
fetch_url ${GUICE_SRC_DESTINATION?} ${GUICE_SRC_URL?}
fetch_url ${CHECKSTYLE_DESTINATION?} ${CHECKSTYLE_URL?}


log "installing eclipse"
tail -n 0 -f ${LOG_FILE?} &
sh includes/eclipse-minimal.sh >> ${LOG_FILE?}


# install my own hobby projects
cd projects
if [ -z "$@" ]; then
	sh projects.sh -a
else
	sh projects.sh "$@"
fi

STAMP_END=$(date +%s)
spent=$(expr "$STAMP_END" '-' "$STAMP_START")
echo "total time spent = $spent seconds"



