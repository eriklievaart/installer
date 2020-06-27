#!/bin/sh

# global properties
HOME=~
if [ "$HOME" = "/root" ]; then
	HOME=/home/${SUDO_USER:?}
fi

GIT_DIR=$HOME/Development/git
INSTALLER_DIR=${GIT_DIR?}/installer
IBIN_DIR=${INSTALLER_DIR?}/ibin


