# io.pl generated from libpl-0.1/src/io.pl 2024-09-04
{ # I/O ROUTINES

sub writefile { open(O,">$_[0]") or die "$_[0]: $!"; print O $_[1]; close(O) }

} # R.Jaksa 2003,2024 GPLv3
