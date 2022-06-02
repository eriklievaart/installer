#!/bin/dash

cd() {
	builtin cd $@
	/opt/q/jump.pl -u "$PWD"
}

q() {
	lines="$(/opt/q/jump.pl -f $@)"
	if [ "$lines" != "" ]; then
		[ $(echo "$lines" | wc -l) -gt 1 ] && echo "$lines"
		[ "$1" != "" ] && builtin cd "$(echo "$lines" | tail -n 1)"
		/opt/q/jump.pl -u "$PWD"
	fi 
}


