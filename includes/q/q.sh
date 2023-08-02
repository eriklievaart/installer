#!/bin/dash

cd() {
	builtin cd "$@"
	/opt/q/jump.pl -u "$PWD"
}

_q() {
	flag="$1"
	shift
	lines="$(/opt/q/jump.pl $flag $@)"
	if [ "$lines" != "" ]; then
		[ $(echo "$lines" | wc -l) -gt 1 ] && echo "$lines"
		builtin cd "$(echo "$lines" | tail -n 1)"
		/opt/q/jump.pl -u "$PWD"
	fi
}

q() {
	_q -i $@
}

qq() {
	_q -f $@
}

