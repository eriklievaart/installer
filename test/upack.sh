#!/bin/sh

set -e
sh -n `basename $0`

spool=/tmp/spool

verify=$spool/verify
verify_dir=$verify/source
verify1=a.txt
verify2=nested/b.txt

parent=$spool/parent
source=$parent/source
nested=$source/nested
file1=$source/$verify1
file2=$source/$verify2
script=$PWD/../bin/pack

dirzip=$parent/source.zip
filezip=$source/a.zip
dirtar=$parent/source.tar
filetar=$source/a.tar
dirgz=$dirtar.gz
filegz=$filetar.gz




die() {
    echo >&2 "$@"
    exit 1
}

clean() {
	if [ -d "$spool" ]; then
		rm -rf "$spool"
	fi
}

init() {
	clean
	mkdir -p ${source?}
	mkdir -p ${verify?}
	mkdir -p ${nested?}
	echo "first" > $file1
	echo "second" > $file2
	echo
	echo "#####################################"
	echo "## $1"
	echo "#####################################"
}

check_file() {
	echo
	tree --noreport $verify
	echo
	check ${verify?}/${verify1?}
	clean
}

check_dir() {
	echo
	tree --noreport $verify
	echo
	check ${verify_dir?}/${verify1?}
	check ${verify_dir?}/${verify2?}
	clean
}

check() {
	for entry in $@
	do
		[ -f ${entry?} ] || die "$entry not found"
	done
}

pack() {
	echo "pack $1 $2"
	sh $script ${1?} ${2?}
}




init "pack zip for file absolute path"
pack -z $file1
unzip "${filezip?}" -d "${verify?}"
check_file

init "pack zip for dir"
pack -z $source
unzip "${dirzip?}" -d "${verify?}"
check_dir

init "pack tar for file"
pack -t $file1
tar -vxf ${filetar?} -C ${verify?}
check_file

init "pack tar for dir"
pack -t $source
tar -vxf ${dirtar?} -C ${verify?}
check_dir

init "pack tar.gz for file"
pack -g $file1
tar -vxf ${filegz?} -C ${verify?}
check_file

init "pack tar.gz for dir"
pack -g $source
tar -vxf ${dirgz?} -C ${verify?}
check_dir

init "pack zip for file relative path"
cd $source
pack -z a.txt
unzip "${filezip?}" -d "${verify?}"
check_file

init "pack zip for dir relative path"
cd $parent
pack -z source
unzip "${dirzip?}" -d "${verify?}"
check_dir


echo '\033[0;1;32msucces!\033[0m'

