#!/bin/sh

set -e

# This script creates a lightweight installation of Eclipse without bloat

ECLIPSE_LAUNCHER=~/bin/eclipse
ECLIPSE_VERSION=4.7.3a
ECLIPSE_INSTALL=~/Applications/eclipse/$ECLIPSE_VERSION
ECLIPSE_PLUGINS=$ECLIPSE_INSTALL/plugins

ECLIPSE_PLATFORM_URL="http://mirror.csclub.uwaterloo.ca/eclipse/eclipse/downloads/drops4/R-4.7.3a-201803300640/eclipse-platform-4.7.3a-linux-gtk-x86_64.tar.gz"
ECLIPSE_PLATFORM_CACHE=~/.cache/eclipse/platform/eclipse-platform-$ECLIPSE_VERSION.tar.gz

ECLIPSEINIT_URL="http://www.eriklievaart.com/download?file=eclipseinit"
ECLIPSEINIT_CACHE=~/.cache/eclipse/plugin/eclipseinit.jar




bin/wgetc $ECLIPSE_PLATFORM_CACHE $ECLIPSE_PLATFORM_URL


if [ -d "$ECLIPSE_INSTALL" ]
then
	echo "eclipse already installed"

else
	mkdir -p $ECLIPSE_INSTALL

	# install launcher
	sed "s/@version@/$ECLIPSE_VERSION/" bin/eclipse > "$ECLIPSE_LAUNCHER"
	chmod +x "$ECLIPSE_LAUNCHER"

	# install binaries
	echo "unpacking $ECLIPSE_PLATFORM_CACHE to $ECLIPSE_INSTALL"
	tar -v -xf "$ECLIPSE_PLATFORM_CACHE" -C "$ECLIPSE_INSTALL"  --strip 1

	# install plugins
	echo "installing jdt, this may take a while..."
	$ECLIPSE_INSTALL/eclipse -noSplash -application org.eclipse.equinox.p2.director -repository http://download.eclipse.org/eclipse/updates/4.7 -installIUs org.eclipse.jdt.feature.group
	bin/wgetc $ECLIPSEINIT_CACHE $ECLIPSEINIT_URL $ECLIPSE_PLUGINS

	# remove intro screen
	rm $ECLIPSE_PLUGINS/org.eclipse.ui.intro*.jar
fi


