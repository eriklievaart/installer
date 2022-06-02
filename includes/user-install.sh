#!/bin/dash
set -e

. ./globals.sh

LOG_DIR=/tmp/installer
LOG_FILE=$LOG_DIR/installer_$(date +%y-%m-%d_%T).log
UP_TO_DATE=false
CACHE_DIR=~/.cache

ECLIPSE_MINIMAL_URL="http://eriklievaart.com/download?file=eclipseminimal"
ECLIPSE_MINIMAL_CACHE=~/.cache/eclipse.zip
ECLIPSE_INSTALL=~/Applications/eclipse

ANT_JUNIT_VERSION=1.8.4
ANT_JUNIT_DESTINATION=~/.ant/lib/ant-junit.jar
ANT_JUNIT_URL="https://repo1.maven.org/maven2/org/apache/ant/ant-junit/$ANT_JUNIT_VERSION/ant-junit-$ANT_JUNIT_VERSION.jar"
ANT_BSH_DESTINATION=~/.ant/lib/ant-bsh.jar
ANT_BSH_URL="https://repo1.maven.org/maven2/org/beanshell/bsh/2.0b5/bsh-2.0b5.jar"

GUICE_VERSION=1.0
GUICE_SRC_JAR_NAME="guice-$GUICE_VERSION-src.jar"
GUICE_SRC_DESTINATION=~/Development/repo/remote/com/google/inject/guice/1.0/$GUICE_SRC_JAR_NAME
GUICE_SRC_URL="http://eriklievaart.com/download?file=guice1src"


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

	# delete the file if it exists, but is 0 bytes
	[ -e "$destination" -a ! -s "$destination" ] && rm -f "$destination"
	if [ -f ${destination?} ]
	then
		log "already downloaded: ${destination?}"
	else
		sh ${IBIN_DIR?}/wgetc $url ${destination?}
	fi
}

create_link() {
	existing="$1"
	link="$2"
	if [ ! -e ${existing?} ]; then
		echo "cannot create link to missing path '$location'"
		exit 1
	fi
	if [ -e "$link" ]; then
		echo "link exists: $link"
	else
		echo "linking: $link -> $existing"
		[ -L "$link" ] && rm -f "$link"
		ln -s "$existing" "$link"
	fi
}

# user "root" cannot run this script
if [ "$HOME" = "/root" ]; then
    echo >&2 "do not run script as root!"
	exit 1
fi

if [ ! -f ~/.gitconfig ]
then
	git config --global user.name "nospam"
	git config --global user.email "nospam"
	git config --global credential.helper cache
	git config pull.rebase true
fi

# firefox settings
if [ -d ~/.mozilla ]; then
	file=$(find ~/.mozilla -name prefs.js | head -n 1)
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
	chmod +x ${IBIN_DIR:?}/*
	echo "export IBIN=${IBIN_DIR?}" >> ~/.profile
	echo 'PATH=$PATH:~/bin:$IBIN' >> ~/.profile
fi

if [ ! -d ~/bin ]; then
	mkdir ~/bin
	PATH=$PATH:~/bin
fi

if grep -q 'HISTSIZE' ~/.bashrc; then
	sed -i 's/HISTSIZE=.*/HISTSIZE=10000/' ~/.bashrc
	sed -i 's/HISTFILESIZE=.*/HISTFILESIZE=20000/' ~/.bashrc
else
	echo >> ~/.bashrc
	echo "HISTSIZE=10000" >> ~/.bashrc
	echo "HISTFILESIZE=20000" >> ~/.bashrc
fi

if ! grep -q '.bash_aliases' ~/.bashrc; then
	echo >> ~/.bashrc
	echo ". ~/.bash_aliases" >> ~/.bashrc
fi

link_dir=link/home
for dir in $(find ${link_dir?} -type d | sed "s|$link_dir||;s|/?$|/|")
do
	[ -e ~/"$dir" ] || mkdir -p ~/"$dir"
done

for file in $(find ${link_dir?} -type f)
do
	dir=~/"$(echo "${file%/*}/" | sed "s|${link_dir?}||;s|^/||")"
	link="${dir?}${file##*/}"
	create_link "$PWD/${file?}" "${link?}"
done

# vim plugins
[ -d ~/.vim/pack ] || mkdir -p ~/.vim/pack
cd ~/.vim/pack
[ -d colorizer ] || git clone https://github.com/lilydjwg/colorizer  colorizer/start/colorizer
[ -d emmet ]     || git clone https://github.com/mattn/emmet-vim.git emmet/start/emmet
if [ ! -d tpope ]; then
	git clone https://github.com/tpope/vim-fugitive                  tpope/start/fugitive
    git clone https://github.com/tpope/vim-surround                  tpope/start/surround
fi
if [ ! -d airline ]; then
	git clone https://github.com/vim-airline/vim-airline             airline/start/airline
	git clone https://github.com/vim-airline/vim-airline-themes      airline/start/airline-themes
fi
cd -
# generate help files
for dir in $(find ~/.vim/pack -type d -name doc)
do
    vim -u NONE -c "$dir" -c q
done


# configure xed text editor
if [ "$display" != "" ]; then
	dconf write /org/x/editor/preferences/editor/scheme "'cobalt'"
	[ -f ~/.config/mimeapps.list ] || touch ~/.config/mimeapps.list
	sed -i 's/mousepad.desktop/xed.desktop/g' ~/.config/mimeapps.list
	sed -i '/^text\/plain=/d;$s|$|\ntext/plain=xed.desktop|' ~/.config/mimeapps.list
fi

# configure xfce terminal
[ ! -d ~/.config/xfce4/terminal ] && mkdir -p ~/.config/xfce4/terminal
[ ! -f ~/.config/xfce4/terminal/terminalrc ] && echo '[Configuration]' > ~/.config/xfce4/terminal/terminalrc
sed -i '/MiscShowUnsafePasteDialog/d' ~/.config/xfce4/terminal/terminalrc
echo 'MiscShowUnsafePasteDialog=FALSE' >> ~/.config/xfce4/terminal/terminalrc

# configure sakura
[ -d ~/.config/sakura ] || mkdir -p ~/.config/sakura
sakura_config=~/.config/sakura/sakura.conf
if [ -f "$sakura_config" ]; then
	sed -i 's/less_questions=false/less_questions=true/' $sakura_config;
else
	echo "[sakura]\nless_questions=true" > $sakura_config
fi

fetch_url ${ANT_BSH_DESTINATION?} ${ANT_BSH_URL?}
fetch_url ${ANT_JUNIT_DESTINATION?} ${ANT_JUNIT_URL?}
fetch_url ${GUICE_SRC_DESTINATION?} ${GUICE_SRC_URL?}


log "installing eclipse"
${IBIN_DIR?}/wgetc "${ECLIPSE_MINIMAL_URL?}" "${ECLIPSE_MINIMAL_CACHE?}"
if [ -d "${ECLIPSE_INSTALL?}" ]; then
    echo "eclipse already installed"
else
	mkdir -p "${ECLIPSE_INSTALL?}"
    echo "unpacking ${ECLIPSE_MINIMAL_CACHE} to ${ECLIPSE_INSTALL?}"
    unzip "${ECLIPSE_MINIMAL_CACHE?}" -d "${ECLIPSE_INSTALL?}"
fi


if crontab -l | grep -q '/tmp/a'; then
    echo crontab already installed
else
    echo '@reboot mkdir /tmp/a' | crontab -
fi


