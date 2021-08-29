#!/bin/dash

dir=/home/automated/Development/git/installer
docker build -f dockerfile -t installer .
docker run -it --rm --network=shared -v ${PWD%/*}:$dir installer $dir/test/entrypoint.sh




