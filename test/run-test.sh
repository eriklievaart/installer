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

echo
echo "@@@@ in the container run @@@@"
echo "/installer/test/entrypoint.sh"
echo
docker run -it --rm --name test --network=shared -v ${PWD%/*}:$dir installer bash




