#!/bin/bash
# usage: ./install    = skip projects
# usage: ./install -a = git pull & install projects
# usage: ./install -i = install projects
# usage: ./install -g = git pull projects
# usage: ./install -s = skip projects
set -e

STAMP_START=$(date +%s)
. includes/globals.sh

# user "root" cannot run this script
if [ "$HOME" = "/root" ]; then
    echo >&2 "do not run script as root!"
	exit 1
fi

cd includes
	sudo dash root-install.sh
	dash user-install.sh
cd -

# install my own hobby projects
cd projects
if [ ! -z "$@" ]; then
	./projects.sh "$@"
fi
cd -

STAMP_END=$(date +%s)
spent=$(expr "$STAMP_END" '-' "$STAMP_START")
echo "total time spent = $spent seconds"

# load bashrc, sourcing does not work from script
exec bash


