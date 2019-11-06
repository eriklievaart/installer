#!/usr/bin/perl
use 5.26.1;
no strict "vars";

$path = $ARGV[0];
$tmp = '/tmp/waz.txt';
say "modifying: '$path'";

open IN, '<', $path;
open OUT, '>', $tmp;

sub trim {
	$in = $_[0];
	$trimmed = $_[0] =~ s/\s++$//r ;
	$trimmed =~ s/^\s++//;
	$trimmed;
}

sub transferUntil {
	$until = $_[0];
	while(<IN>) {
		print OUT "$_";
		chomp;
		$trimmed = trim $_;
		if ($trimmed eq $until) {
			say "transferred until line '$_'";
			last;
		}
	}
}

sub registerSpells {
	say "registering spells";
	@spells = `cat perl/spells.txt | sed -r '/^\\s*\$/d'`;
	chomp @spells;
	$count = @spells;
	say OUT "    count $count";

	# register spells
	for ($i=0; $i < $count; $i++) {
		say OUT "    $i";
		say OUT "     type " . $spells[ $i ] =~ s/\s.*//r;
		say OUT "     forgetTime 9999.9876760914922";
	}
	# skip previously registered spells
	while (<IN>) {
		if (/nutrition/) {
			say OUT "   nutrition 999.999999";
			last;
		}
	}
}

transferUntil "label";
$name = <IN>;
print OUT $name;
chomp $name;
$name =~ s/.*name/#/;
say "name: '$name'";
transferUntil $name;
transferUntil "spells";
registerSpells;
transferUntil "#EOF";

close IN;
close OUT;

system "diff $path $tmp";
system "cp $tmp $path";

