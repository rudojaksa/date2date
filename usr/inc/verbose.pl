# verbose.pl generated from verbose-0.3/src/verbose.pl 2024-09-28
{ # VERBOSE KEY-MESSAGE-COMMENT -------------------------------------------------------------- CONFIG
# include string.pl colors.pl

# key length
our $VERBOSE_KLEN = 10;

# explicit colors
our ($VERBOSE_C1,$VERBOSE_C2,$VERBOSE_C3);

# prefix/suffix
our ($VERBOSE_PX1,$VERBOSE_PX2,$VERBOSE_PX3);
our ($VERBOSE_SX1,$VERBOSE_SX2,$VERBOSE_SX3); $VERBOSE_SX1=":";

# key words for color of key and for color of message
our (%VERBOSE_WORD,%VERBOSE_WORD2);
#   $VERBOSE_WORD{$_} =$CM_ for split / /,"cmd save update";
#   $VERBOSE_WORD2{$_}=$CM_ for split / /,"cmd";
    $VERBOSE_WORD{$_} =$CR_ for split / /,"error";
    $VERBOSE_WORD2{$_}=$CR_ for split / /,"error";

# key patterns
our %VERBOSE_PAT;
    $VERBOSE_PAT{qr/^[A-Z]+$/} = $CC_;	# cyan for uppercase words

# ---------------------------------------------------------------------------------------- FORMATTING

our sub announce {
  my ($K,$M,$C) = @_;	# key/message/comment
  $M = unnl $M;
  $C = unnl $C;
  # $M = "$CK_\[]$CD_" if $M eq ""; # default empty message: [] # TODO: later and systematicaly

  my ($c1,$c2,$c3);	# colors
  my ($e1,$e2,$e3);	# end of color

  # key/message color
  if(not defined $VERBOSE_C1) {
    for(keys %VERBOSE_PAT) { $c1=$VERBOSE_PAT{$_} if $K=~/$_/ }
    for(keys %VERBOSE_WORD) { $c1=$VERBOSE_WORD{$_} if $K=~/(^|[^a-zA-Z0-9_-])$_([a-zA-Z0-9_-]|$)/ }}
  if(not defined $VERBOSE_C2) {
    for(keys %VERBOSE_WORD2) { $c2=$VERBOSE_WORD2{$_} if $K=~/(^|[^a-zA-Z0-9_-])$_([a-zA-Z0-9_-]|$)/ }}

  # comment color
  if(not defined $VERBOSE_C3) { $c3=$CK_ }

  # explicit color
  $c1=$VERBOSE_C1 if defined $VERBOSE_C1;
  $c2=$VERBOSE_C2 if defined $VERBOSE_C2;
  $c3=$VERBOSE_C3 if defined $VERBOSE_C3;

  # end of color
  $e1=$CD_; $e1="" if not defined $c1 or $c1 eq "" or $c1 eq $CD_;
  $e2=$CD_; $e2="" if not defined $c2 or $c2 eq "" or $c2 eq $CD_;
  $e3=$CD_; $e3="" if not defined $c3 or $c3 eq "" or $c3 eq $CD_;

  # output
  my $s;

  # key
  my $sp = " " x ($VERBOSE_KLEN-esclen($K)); # space for right alignment
  $s .= $sp.$c1.$VERBOSE_PX1.$K.$VERBOSE_SX1.$e1;

  # message
  $s .= " ".$c2.$VERBOSE_PX2.$M.$VERBOSE_SX2.$e2 if defined $M and $M ne "";

  # comment
  $s .= " ".$c3.$VERBOSE_PX3.$C.$VERBOSE_SX3.$e3 if defined $C and $C ne "";

  print STDERR "$s\n" }

# ------------------------------------------------------------------------------------------ WRAPPERS

our sub verbose { announce @_ if $VERBOSE }

# error(key,msg,comm): kmc error in red
# error(str): plain error message in red
# error()exits with zero, warn() doesn't exit
our sub error {
  if(defined $_[1]) { local ($VERBOSE_C1,$VERBOSE_C2)=($CR_,$CR_); announce @_; exit }
  print STDERR "$CR_$_[0]$CD_\n"; exit }
use subs 'warn'; # must use use subs to redefine builtin warn
our sub warn {
  if(defined $_[1]) { local ($VERBOSE_C1,$VERBOSE_C2)=($CR_,$CR_); announce @_; return }
  print STDERR "$CR_$_[0]$CD_\n" }

# break and exit (with zero), break = break messaging with an ampty line
our sub brexit { print STDERR "\n"; exit }

# ------------------------------------------------------------------------------------ COLOR SPECIFIC
# color-specific variants, use localized global variables to affect only the single announce call

our sub announce_rq { local ($VERBOSE_C1,$VERBOSE_SX1)=($CR_,"?"); announce @_ }
our sub announce_rw { local ($VERBOSE_C1,$VERBOSE_C2)=($CR_,$CW_); announce @_ }

our sub verbose_cc { return if not $VERBOSE; local ($VERBOSE_C1,$VERBOSE_C2)=($CC_,$CC_); announce @_ }
our sub verbose_cr { return if not $VERBOSE; local ($VERBOSE_C1,$VERBOSE_C2)=($CC_,$CR_); announce @_ }
our sub verbose_cg { return if not $VERBOSE; local ($VERBOSE_C1,$VERBOSE_C2)=($CC_,$CG_); announce @_ }
our sub verbose_ck { return if not $VERBOSE; local ($VERBOSE_C1,$VERBOSE_C2)=($CC_,$CK_); announce @_ }
our sub verbose_dr { return if not $VERBOSE; local ($VERBOSE_C1,$VERBOSE_C2)=($CD_,$CR_); announce @_ }
our sub verbose_rr { return if not $VERBOSE; local ($VERBOSE_C1,$VERBOSE_C2)=($CR_,$CR_); announce @_ }
our sub verbose_mm { return if not $VERBOSE; local ($VERBOSE_C1,$VERBOSE_C2)=($CM_,$CM_); announce @_ }
our sub verbose_mg { return if not $VERBOSE; local ($VERBOSE_C1,$VERBOSE_C2)=($CM_,$CG_); announce @_ }
our sub verbose_mk { return if not $VERBOSE; local ($VERBOSE_C1,$VERBOSE_C2)=($CM_,$CK_); announce @_ }
our sub verbose_kk { return if not $VERBOSE; local ($VERBOSE_C1,$VERBOSE_C2)=($CK_,$CK_); announce @_ }
our sub verbose_kg { return if not $VERBOSE; local ($VERBOSE_C1,$VERBOSE_C2)=($CK_,$CG_); announce @_ }
our sub verbose_pp { return if not $VERBOSE; local ($VERBOSE_C1,$VERBOSE_C2)=($CP_,$CP_); announce @_ }
our sub verbose_dw { return if not $VERBOSE; local ($VERBOSE_C1,$VERBOSE_C2)=("",$CW_); announce @_ }

# ---------------------------------------------------------------------------------------------------

# black-green-path: directory=black filename=green
our sub bgpath { my $f=$_[0];
  $f =~ s/^(.*\/)?(.*?)$/$CK_$1$CG_$2$CD_/;
  return $f }

our sub call { verbose "cmd",$_[0]; return `$_[0]` }

} # ------------------------------------------------------------------ # R.Jaksa 2019,2023,2024 GPLv3
