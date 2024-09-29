# string.pl generated from libpl-0.1/src/string.pl 2024-09-04
{ # SIMPLE STRING ROUTINES

# remove the last newline from string
our sub nonl { my $s=$_[0]; chomp $s; return $s }

# remove all newlines from a string, replace them with spaces
our sub unnl {
  my $s=$_[0];
  $s =~ s/\n+$//;
  $s =~ s/\n/ /g;
  return $s }

} # R.Jaksa 2024 GPLv3
