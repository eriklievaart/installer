#!/bin/dash
set -e
. ./globals.sh

LOG_DIR=/tmp/installer
LOG_FILE=$LOG_DIR/installer_$(date +%y-%m-%d_%T).log
UP_TO_DATE=false
CACHE_DIR=~/.cache


log() {
	if [ ! -d "$LOG_DIR" ]
	then
		mkdir $LOG_DIR
	fi
	echo $1
	echo $1 >> $LOG_FILE
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




#for file in $(ls -a "${link_dir?}" | sed -n '/[.]*[^.].*/p')
#do
	#location=$PWD/$link_dir/$file
	#link=~/$file
	#create_link "$location" "$link"
#done

