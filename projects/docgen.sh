#!/bin/sh
set -e

preinstalled=/usr/share/doc
target=~/Applications/doclauncher/api

# link java api from preinstalled location
for dir in $(ls ${preinstalled-} | grep jdk | grep doc)
do
	for api in $(find ${preinstalled-}/$dir -name api)
	do
		version=$(echo $dir | sed -r 's/[^0-9]+//g')
		destination=$target/java$version
		[ -e $destination ] || ln -s $api $destination
	done
done

# generate javadoc from maven source
root=~/Development/repo
for file in $(find $root | grep 'src.jar' | sort)
do
	name=$(echo "$file" | sed -r 's:.*/::;s:(-[0-9.]+)?-src.jar$::')
	src="/tmp/spool/src/$name"
	destination=$target/$name
	if [ -e $destination ]
	then
		continue
	fi
	if [ ! -e "$destination" -a "$(unzip -l $file | grep '.java$')" != "" ]
	then
		echo "$file"
		mkdir -p $src
		unzip -n $file -d $src
		pwd
		ant -f javadoc.xml -Dlib=$name
	fi
done



