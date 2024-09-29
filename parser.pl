{ # GENERIC PARSING SUPPORT

# start/end of stored-text pattern, plus their qoutemeta versions
# * these are non-text unusual patterns to appear in the string
# * start and end patterns are different, and indicate direction
our $STX = "\001\002"; our $STQ = qr/\\\001\\\002/;
our $ETX = "\003\001"; our $ETQ = qr/\\\003\\\001/;

# debug functions ta visualize strings containing STX/ETX markers
our sub untx { my $s=$_[0]; $s=~s/\001\002/$CK_=>$CD_/g; $s=~s/\003\001/$CK_<=$CD_/g; return $s }
our sub prtx { print STDERR "  $_[0]: ".untx($_[1])."\n" } # prtx "key",$data;

} # R.Jaksa 2024 GPLv3
