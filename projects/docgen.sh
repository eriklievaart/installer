#!/bin/sh
set -e

root=~/Development/repo
for file in $(find $root | grep 'src.jar' | sort)
do
	name=$(echo "$file" | sed -r 's:.*/::;s:(-[0-9.]+)?-src.jar$::')
	src="/tmp/spool/src/$name"
	destination=~/Applications/doclauncher/api/$name
	if [ -e $destination ]
	then
		continue
	fi
	if [ ! -e "$destination" -a "$(unzip -l $file | grep '.java$')" != "" ]
	then
		echo "bla $file"
		mkdir -p $src
		unzip -n $file -d $src
		pwd
		ant -f javadoc.xml -Dlib=$name
	fi
done
