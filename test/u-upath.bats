#!/usr/bin/env bats

# upath -b (base)
@test "base of .hidden" {
	result="$(sh ../bin/upath -b .hidden)"
	[ "$result" = ".hidden" ]
}

@test "base of trailingdot." {
	result="$(sh ../bin/upath -b trailingdot.)"
	[ "$result" = "trailingdot." ]
}

@test "base of /tmp/" {
	result="$(sh ../bin/upath -b /tmp/)"
	[ "$result" = "tmp" ]
}

@test "base of a.jpg" {
	result="$(sh ../bin/upath -b a.jpg)"
	[ "$result" = "a" ]
}

@test "base of b.tar.gz" {
	result="$(sh ../bin/upath -b b.tar.gz)"
	[ "$result" = "b.tar" ]
}

@test "base of file.has.dots" {
	result="$(sh ../bin/upath -b file.has.dots.txt)"
	[ "$result" = "file.has.dots" ]
}

@test "base of /tmp/path/to/file.with.dots.txt" {
	result="$(sh ../bin/upath -b /tmp/path/to/file.with.dots.txt)"
	[ "$result" = "file.with.dots" ]
}




# upath -e (extension)
@test "extension of none" {
	result="$(sh ../bin/upath -e none)"
	echo "$result"
	[ "$result" = "" ]
}

@test "extension of trailingdot." {
	result="$(sh ../bin/upath -e trailingdot.)"
	[ "$result" = "" ]
}

@test "extension of .hidden" {
	result="$(sh ../bin/upath -e .hidden)"
	[ "$result" = "" ]
}

@test "extension of a.jpg" {
	result="$(sh ../bin/upath -e a.jpg)"
	[ "$result" = "jpg" ]
}

@test "extension of b.tar.gz" {
	result="$(sh ../bin/upath -e b.tar.gz)"
	[ "$result" = "gz" ]
}

@test "extension of file.has.dots" {
	result="$(sh ../bin/upath -e file.has.dots.txt)"
	[ "$result" = "txt" ]
}

@test "extension of /tmp/path/to/file.with.dots.txt" {
	result="$(sh ../bin/upath -e /tmp/path/to/file.with.dots.txt)"
	[ "$result" = "txt" ]
}




# upath -n (name)
@test "name of trailingdot." {
	result="$(sh ../bin/upath -n trailingdot.)"
	[ "$result" = "trailingdot." ]
}

@test "name of .hidden" {
	result="$(sh ../bin/upath -n .hidden)"
	[ "$result" = ".hidden" ]
}

@test "name of no-extension" {
	result="$(sh ../bin/upath -n no-extension)"
	[ "$result" = "no-extension" ]
}

@test "name of a.jpg" {
	result="$(sh ../bin/upath -n a.jpg)"
	[ "$result" = "a.jpg" ]
}

@test "name of b.tar.gz" {
	result="$(sh ../bin/upath -n b.tar.gz)"
	[ "$result" = "b.tar.gz" ]
}

@test "name of file.has.dots" {
	result="$(sh ../bin/upath -n file.has.dots.txt)"
	[ "$result" = "file.has.dots.txt" ]
}

@test "name of /tmp/path/to/file.with.dots.txt" {
	result="$(sh ../bin/upath -n /tmp/path/to/file.with.dots.txt)"
	[ "$result" = "file.with.dots.txt" ]
}




# upath -p (parent)
@test "parent of .hidden" {
	run sh ../bin/upath -p .hidden
	[ "$status" -eq 255 ]
}

@test "parent of a.jpg" {
	run sh ../bin/upath -p a.jpg
	[ "$status" -eq 255 ]
}

@test "parent of ." {
	run sh ../bin/upath -p .
	[ "$status" -eq 255 ]
}

@test "parent of /" {
	run sh ../bin/upath -p /
	[ "$status" -eq 255 ]
}

@test "parent of /tmp/" {
	result="$(sh ../bin/upath -p /tmp/)"
	[ "$result" = "/" ]
}

@test "parent of /tmp/nested/" {
	result="$(sh ../bin/upath -p /tmp/nested/)"
	echo "$result"
	[ "$result" = "/tmp/" ]
}

@test "parent of /tmp/path/to/file.with.dots.txt" {
	result="$(sh ../bin/upath -p /tmp/path/to/file.with.dots)"
	echo "$result"
	[ "$result" = "/tmp/path/to/" ]
}




