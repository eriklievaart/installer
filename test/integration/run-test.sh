#!/bin/dash
# ./run-test.sh       -> runs test suite
# ./run-test.sh -i    -> start bash
set -e

echo docker networks:
docker network list
if [ -z "$(docker network list | awk '/shared/{print $2}')" ]; then
	docker network create shared
fi

echo
if docker ps | grep -q apt-cacher; then
    echo "docker: found running apt-cacher"
else
    echo "docker: starting apt-cacher"
    docker run --rm -d --name 'apt-cacher' --network=shared -v ~/.cache/apt-cacher:/var/cache/apt-cacher apt-cacher
fi

echo
docker build -f dockerfile -t installer .
docker run -it --rm --name test --network=shared -v ~/Development/git/installer:/installer installer /installer/test/integration/entrypoint.sh $1




