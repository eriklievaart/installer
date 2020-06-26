#!/bin/sh

# global properties
GIT_DIR=~/Development/git
INSTALLER_DIR=${GIT_DIR?}/installer
IBIN_DIR=${INSTALLER_DIR?}/ibin
HOME=~
if [ "$HOME" = "/root" ]; then
	HOME=/home/${SUDO_USER:?}
fi



