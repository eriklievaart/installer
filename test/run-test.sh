#!/bin/dash
set -e

if docker ps | grep -q apt-cache; then
	echo "apt-cache is running"
else
	echo "*error* apt-cache not available!"
	exit 1
fi

dir=/installer
docker build -f dockerfile -t installer .
docker run -it --rm --network=shared -v ${PWD%/*}:$dir installer $dir/test/entrypoint.sh




