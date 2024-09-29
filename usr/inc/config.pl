# config.pl generated from config-0.1/src/config.pl 2024-09-29
{ # DOT-CONFIG ROUTINES
  # required array.pl colors.pl

our @cfg_checked; # for verbose: files checked in addition to the one found

# remove leading dots from string
my sub undot { my $s=$_[0]; $s=~s/^\.*//; return $s }

# check .cfgfile in the CWD
# $file = cfgfile_cwd($name,$cwd)
# $cwd is optional for the cases where we are already in different directory
our sub cfgfile_cwd {
  my $name = undot $_[0];
  my $cwd = $_[1];
  if(defined $cwd) {
    return "$cwd/.$name" if -f "$cwd/.$name";
    push @cfg_checked,"$cwd/.$name" }
  else {
    return ".$name" if -f ".$name";
    push @cfg_checked,".$name" }
  return } # explicit return of undef

# check ..cfgfile in parentdirs
# $file = cfgfile_parents($name,$cwd)
# provided $cwd is honored, i.e. we will fail if it doesn't exist
our sub cfgfile_parents {
  my $name = undot $_[0];
  my $dir; my $cwd = $_[1];
  if(defined $cwd) { return if not -d $cwd; $dir = $cwd }
  else { $dir = `pwd`; chomp $dir }
  while($dir) {
    my $f = "$dir/..$name";
    $dir =~ s/\/[^\/]*$//; # remove last subdir part
    if(-f $f) { return $f } else { push @cfg_checked,$f }
    last if $dir =~ /^\/home\/?[^\/]*$/ } # skip /home/user and /home
  return }

# check .cfgfile in home dir
our sub cfgfile_home {
  my $name = undot $_[0];
  my $f = "/home/$ENV{USER}/.$name";
     $f = "$ENV{HOME}/.$name" if defined $ENV{HOME};
  return $f if -f $f;
  push @cfg_checked,$f;
  return }

# $file = cfgfile($name)
# $file = cfgfile($name,$cwd)
our sub cfgfile {
  my ($name,$cwd) = @_;
  my $cfg = cfgfile_cwd $name;
     $cfg = cfgfile_parents $name,$cwd if not $cfg;
     $cfg = cfgfile_home $name if not $cfg;
  return $cfg }

# parsers: key-colon-value, unerstands doublequoted values and hash comments
# returns hash of scalars or hash of arrays for multiple-keys syntax

# return raw array of values per key
our sub cfgparse_arr {
  my $file = $_[0];
  return if not -f $file;
  my %cfg;
  open $handle,"$file" or die "$file: $!";
  for my $line (<$handle>) {
    chomp $line;
    next if $line=~/^[\h\n]*$/;
    next if $line=~/^\h*\#/;
    push @{$cfg{$1}},$2 if $line =~ /^\h*([^:]+):\h+(.*?)\h*(\h\#.+)?$/ }
  close $handle;
  return %cfg }

# return sclar per key, combine multiple values as a space seeparatod string
our sub cfgparse {
  my %cfg1 = cfgparse_arr $_[0];
  my %cfg;
  for my $k (keys %cfg1) {
    my @arr; pushq \@arr,$_ for @{$cfg1{$k}}; # skip duplicities
    $cfg{$k} = join " ",@arr }
  return %cfg }

# nice-print cfg
our sub cfgdebug { print "$CC_$_:$CD_ $_[0]{$_}\n" for keys %{$_[0]} }
our sub cfgdebug_arr { for my $k (keys %{$_[0]}) { print "$CC_$k:$CD_ $_\n" for @{$_[0]{$k}} }}

} # R.Jaksa 2021,2024 GPLv3
