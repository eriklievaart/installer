#!/usr/bin/perl
use 5.27.1;

my $root="$ENV{'HOME'}/.cache/q";
my $cache="$root/visited.txt";
system "mkdir -p $root";

sub trim {
	my $trimmed = $_[0] =~ s/\s++$//r ;
	$trimmed =~ s/^\s++//;
	$trimmed;
}

# fill @paths will all paths available
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

# delete all entries that don't have all passed parts in order
sub filter_parameters {
	ELEMENT: for (my $i = 0; $i<$#_+1; $i++) {
		my $element=$_[$i];
		my $index=0;
		foreach (@ARGV) {
			$index = index($element, $_, $index);
			if ($index == -1) {
				splice @_, $i--, 1 if ($index == -1);
				last;
			}
		}
	}
	return @_;
}

# last part of query must be in name
sub filter_tail {
	my $tail = @ARGV[$#ARGV] =~ s|.*/|/|r;
	for (my $i = 0; $i<$#_+1; $i++) {
		my $name = $_[$i] =~ s|.*/|/|r;
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

	for (@paths) {
		my $name = $_ =~ s|.*/||r;
		push @filter, $_ if $name eq $tail;
	}
	return @filter if $#filter >= 0;
	return @paths;
}

# select the most appropriate match based on the passed arguments
sub filter {
	my @paths = @_;

	@paths = filter_parameters(@paths);
	@paths = filter_tail(@paths);
	@paths = rm_missing(@paths);
	@paths = prioritize(@paths);
	say $_ for(@paths);

	return @paths;
}

if (@ARGV[0] eq "-u") {
	update(@ARGV[1]);

} elsif(@ARGV[0] eq "-f") {
	shift @ARGV;
	filter(paths());
}




