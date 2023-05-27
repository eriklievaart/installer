#!/bin/perl
# usage
# perl.pl -f [path]     lookup in recently visited list (case sensitive)
# perl.pl -i [path]     lookup in recently visited list (case insensitive)
# perl.pl -u [path]     add file to recently visited list
use 5.26.1;

my $root = "$ENV{'HOME'}/.cache/q";
my $cache = "$root/visited.txt";
my $sensitive = 1;
my $local = 0;
system "mkdir -p $root";

sub trim {
	my $trimmed = $_[0] =~ s/\s++$//r ;
	$trimmed =~ s/^\s++//;
	$trimmed;
}

# fill @paths with all paths available
sub paths() {
	my @paths = ();
	return @paths if(! -f $cache);
	my $noerror = open FILE, '<', $cache;
	if($noerror) {
		while (<FILE>) {
			s|^file:/*|/|;
			push @paths, trim($_);
		}
		close FILE;
		return @paths;
	} else {
		say "error message: $!";
		die "unable to open file $cache";
	}
}

sub update {
	my $pwd = $_[0];
	my @paths = paths();
	shift @paths while $#paths >= 800;
	for (my $i = 0; $i<$#paths+1; $i++) {
        splice @paths, $i--, 1 if $paths[$i] eq $pwd;
	}
	push @paths, $pwd;

	if(open FILE, '>', $cache) {
		say FILE $_ for (@paths);
		close FILE;
	} else {
		say "error message: $!";
		die "unable to open file $cache";
	}
}

# only search in subdirectories if $local flag is set
sub filter_local {
	if($local) {
		for (my $i = 0; $i<$#_+1; $i++) {
			splice @_, $i--, 1 if index($_[$i], %ENV{'PWD'}) != 0;
		}
	}
	return @_;
}

# delete all entries that don't have all passed parts in order
sub filter_parameters {
	for (my $i = 0; $i<$#_+1; $i++) {
		my $element = $sensitive ? $_[$i] : uc($_[$i]);
		my $index = 0;
		foreach (@ARGV) {
			my $arg = $sensitive ? $_ : uc($_);
			$index = index($element, $arg, $index);
			if ($index == -1) {
				splice @_, $i--, 1;
				last;
			}
		}
	}
	return @_;
}

sub tail {
	my $value = $_[0];
	my $result = substr($value, rindex($value, '/') + 1);
	return $sensitive ? $result : uc($result);
}

# last part of query must be in name
sub filter_tail {
	my $tail = tail(@ARGV[$#ARGV]);
	for (my $i = 0; $i<$#_+1; $i++) {
		my $name = tail($_[$i]);
		splice @_, $i--, 1 if index($name, $tail) == -1;
	}
	return @_;
}

# directory must exist
sub rm_missing {
	for (my $i = 0; $i<$#_+1; $i++) {
		splice @_, $i--, 1 if ! -d $_[$i]
	}
	return @_;
}

# if there is an exact match, move that one to last
sub prioritize {
	my $tail = @ARGV[$#ARGV] =~ s|.*/|/|r;

	my @paths = @_;
	my @filter = ();

	# exact match in name
	for (@paths) {
		my $name = $_ =~ s|.*/||r;
		push @filter, $_ if $name eq $tail;
	}
	return @filter if $#filter >= 0;

	# starts with
	for (@paths) {
		my $name = $_ =~ s|.*/||r;
		push @filter, $_ if index($name, $tail) == 0;
	}
	return @filter if $#filter >= 0;

	return @paths;
}

# select the most appropriate match based on the passed arguments
sub filter {
	my @paths = @_;
	my $filter = $#ARGV > -1;

	if ($local) {
		@paths = filter_local(@paths);
	}
	if ($filter) {
		@paths = filter_parameters(@paths);
		@paths = filter_tail(@paths);
		@paths = rm_missing(@paths);
		@paths = prioritize(@paths);
		say "";
	}
	say $_ for(@paths);
	return @paths;
}




sub set_local_flag {
	if (@ARGV[0] eq ".") {
		shift @ARGV;
		$local = 1;
	}
}

if (@ARGV[0] eq "-u") {
	update(@ARGV[1]);

} elsif (@ARGV[0] eq "-f") {
	shift @ARGV;
	set_local_flag();
	filter(paths());
	my $pwd = %ENV{'PWD'};

} elsif (@ARGV[0] eq "-i") {
	shift @ARGV;
	set_local_flag();
	$sensitive = 0;
	filter(paths());

} else {
	say "unknown flag @ARGV";
}


