#!/bin/sh


set -e # fail on errors
sh -n verify.sh # check this file for syntax errors before executing it
sh -n install.sh # check installer for syntax errors before executing it


die() {
    echo >&2 "Unit Test Error: $@"
    exit 1
}





JAVA_VERSION="1.8"

java_installed() {
	return java -version 2>&1 | grep "version" | grep $JAVA_VERSION
}

# remove java
sudo apt-get remove -y openjdk* 
sudo apt-get autoremove
sudo apt-get autoclean

if(java -version 2>&1 | grep "version" | grep $JAVA_VERSION)
then
	die "remove java failed"
fi

# run script
sudo sh install.sh

# verify java is properly installed
if(! java -version 2>&1 | grep "version" | grep $JAVA_VERSION)
then
	die "java install failed"
fi




echo "succes: all tests pass!"

