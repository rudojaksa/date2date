# include .version.pl .date2date.built.pl

our @DIF = ("M/D/Y","D~Mon~Y");	# default input formats
our $DOF = "YYYY-MM-DD";	# default output format
our $MAR = "()[]{}\"\' \t,;";	# margin delimiters

$HELP=<<EOF;

NAME
    date2date - reformat date values

USAGE
    date2date [OPTIONS] FILE [CC(FILE2)]... CK(> OUTPUT_FILE)
    cat FILE | date2date [OPTIONS] CK(> OUTPUT_FILE)

DESCRIPTION
    Find all date/time fields in the file that match the input format and reformat
    them to the output format.

OPTIONS
          -h  This help.
          -v  Verbose messaging using CD(STDERR) (CC(-vv) for additional debug messages).
   -i FORMAT  Date format in input data.  When used multiple times, the first
              value is looked up first, second then... CK((default: @DIF))
   -o FORMAT  Date format for the output. CK((default: $DOF))
     -y YEAR  Default year, this (and the last) year are used if needed.
    -m MONTH  Default month (as number 1..12).
      -d DAY  Default month (as number 1..31).
 -t CC(HOUR:MIN)  Default time (also CC(HOUR:MIN:SEC)).
  CC(-c/r/g/k/w)  Color of replaced fields CC(cyan)/CR(red)/CG(green)/CK(black)/CW(white).

FORMAT
    CC(s)    second                CK( 0  1 ... 59) (decimal too)
    CC(ss)   second two-digit      CK(00 01 ... 59) (decimal too)
    CC(ss.s) one decimal place     CK(00.0 00.1 ... 59.9)
    CC(m)    minute                CK( 0  1 ... 59)
    CC(mm)   minute two-digit      CK(00 01 ... 59)
    CC(h)      hour                CK( 0  1 ... 24)
    CC(hh)     hour two-digit      CK(00 01 ... 24)
    CC(D)       day number         CK( 1  2 ... 31)
    CC(DD)      day two-digit      CK(01 02 ... 31)
#   CC(Day)     day full           CK(Monday Tuesday ... Sunday)
#   CC(D3)      day three-letters  CK(Mon Tue Wen Thu Fri Sat Sun)
#   CC(DA)      day twe-letters    CK(MO TU WE TH FR SA SU)
#   CC(D1)      day one-letter     CK(M T W R F S Y)
#   CC(D0)      day mixed          CK(M Tu W Th F Sat Sun)
    CC(M)     month numerical      CK( 1  2 ... 12)
    CC(MM)    month two-digit      CK(01 02 ... 12)
    CC(Month) month full name      CK(January February ... December)
    CC(Mon)   month three-letters  CK(Jan Feb ... Dec)
    CC(MO)    month two-letters    CK(JA FE MR AP MY JN JL AU SE OC NV DE)
    CC(yyyy)   year safe           CK(1900 ... 2099) (only 19XX and 20XX)
  CC(Y)CK(/)CC(YYYY)   year full           CK(1999 2000 2001 ...) (any from 1000 ... 9999)
    CC(YY)     year two-digit      CK(99 00 01 ...)
    CC(Year)   year                CK(-3500 1999 100000) (any number)
    CC(epoch) epoch ten-digit      CK(0000000000 1234567890 ...) (decimal too)
    CC(Epoch) epoch                CK(0 1234567890 ...) (decimal too)

CONFIG FILE
    Configuration file CC(.date2date) has "key: value" syntax.  Hash CC(#) starts
    a comment.  Tilde CC(~) can be used instead of space.  Double-dot config
    CC(..date2date) file is accepted in all subdirectories and home-directory
    file CC(~/.date2date) is accepted globally for the user.  Example:

    CW(input: M/D/YYYY YYYY/MM/DD  # 2/22/2022 2022/02/22)
    CW(output: D~Mon~YYYY          # 22 Feb 2022)

LIST OF FORMATS
    02/22/2022  CW(MM/DD/YYYY)  USA
    22.02.2022  CW(DD.MM.YYYY)  EUR
    2022-02-22  CW(YYYY-MM-DD)  ISO (ISO 8601, sort-safe)
    9 Feb 2022  CW(D~Mon~YYYY)
    February 22, 2022  CW("Month D, YYYY")
    2022-02-22 22:22   CW("YYYY-MM-DD hh:mm")  ISO date plus time
    02 Feb 2022,22:22  CW(DD~Mon~YYYY,hh:mm)   two fields from/for CSV

EXAMPLES
    Two CSV fields (date and time) to a singel ISO field:
    CW(date2date -i DD~Mon~YYYY,hh:mm -o YYYY-MM-DD~hh:mm file.csv)

VERSION
    $PACKAGE-$VERSION$SUBVERSION CK($AUTHOR) CK(built $BUILT)

EOF

# --------------------------------------------------------------------------------------------- ARGVS
# include colors.pl array.pl io.pl path.pl verbose.pl printhelp.pl

printhelp $HELP and exit 0 if inar \@ARGV,"-h";
for(@ARGV) { next if $_ ne "-v"; $VERBOSE=1; $_=""; last }
for(@ARGV) { next if $_ ne "-vv"; $DEBUG=1; $_=""; last }
$VERBOSE=1 if $DEBUG;

# default year
our ($DY,$DM,$DD,$Dh,$Dm,$Ds);
for(0..$#ARGV-1) { 
  next if $ARGV[$_] ne "-y" or not $ARGV[$_+1]=~/^[\d]+$/;
  $DY=$ARGV[$_+1]; $ARGV[$_]=""; $ARGV[$_+1]=""; last }
for(0..$#ARGV-1) { 
  next if $ARGV[$_] ne "-m" or not $ARGV[$_+1]=~/^[\d]+$/ or $ARGV[$_+1]<1 or $ARGV[$_+1]>12;
  $DM=$ARGV[$_+1]; $ARGV[$_]=""; $ARGV[$_+1]=""; last }
for(0..$#ARGV-1) { 
  next if $ARGV[$_] ne "-d" or not $ARGV[$_+1]=~/^[\d]+$/ or $ARGV[$_+1]<1 or $ARGV[$_+1]>31;
  $DD=$ARGV[$_+1]; $ARGV[$_]=""; $ARGV[$_+1]=""; last }
for(0..$#ARGV-1) { 
  next if $ARGV[$_] ne "-t" or not $ARGV[$_+1]=~/^[\d:]+$/;
  if($ARGV[$_+1]=~/^(\d+)(?::(\d+))?(?::(\d+))?$/) { ($Dh,$Dm,$Ds)=($1,$2,$3) } else { next }
  $ARGV[$_]=""; $ARGV[$_+1]=""; last }

# color
for(@ARGV) { next if $_ ne "-c"; $COLOR="C"; $_=""; last }
for(@ARGV) { next if $_ ne "-r"; $COLOR="R"; $_=""; last }
for(@ARGV) { next if $_ ne "-g"; $COLOR="G"; $_=""; last }
for(@ARGV) { next if $_ ne "-k"; $COLOR="K"; $_=""; last }
for(@ARGV) { next if $_ ne "-w"; $COLOR="W"; $_=""; last }

# input format, multiple accepted
our @IF;
for(0..$#ARGV-1) { 
  next if $ARGV[$_] ne "-i" or $ARGV[$_+1] eq "";
  push @IF,$ARGV[$_+1]; $ARGV[$_]=""; $ARGV[$_+1]="" }

# output format, only first appearance
our $OF;
for(0..$#ARGV-1) { 
  next if $ARGV[$_] ne "-o" or $ARGV[$_+1] eq "";
  $OF=$ARGV[$_+1]; $ARGV[$_]=""; $ARGV[$_+1]=""; last }

# files
our @FILE;
for(0..$#ARGV) { 
  next if $ARGV[$_] eq "" or not -f $ARGV[$_];
  push @FILE,$ARGV[$_]; $ARGV[$_]="" }

# wrong args
$VERBOSE_C1 = $CC_;
$VERBOSE_KLEN = 13;
my @wrong; for(@ARGV) { push @wrong,$_ if $_ ne ""; }
warn "wrong options",join(" ",@wrong) if @wrong;
# error "no input file specified" if not @FILE;

# verbose
verbose "file",bgpath($_) for @FILE;

# margins
my $mar=$MAR; $mar=~s/\t/\\t/; $mar=~s/\n/\\n/; $mar=~s/\r/\\r/;
$MAR = quotemeta $MAR; $MAR = qr/[$MAR]/; # margin delimiters
verbose "margins",$mar,$MAR;

# -------------------------------------------------------------------------------------------- CONFIG
# include config.pl

my $cfg = cfgfile ".date2date";
if($DEBUG) { verbose_kk "checked cfg",$_ for @cfg_checked }
verbose_cg "config",$cfg if $cfg;

my %CFG = cfgparse_arr $cfg if $cfg;

# defaults: if cli value missing, look for the config value, or look for the default
my $IFhow = "CLI"; my $OFhow = "CLI";
if(not @IF) {
  if(defined $CFG{input}) { @IF=@{$CFG{input}}; $IFhow=$cfg }
  else			  { @IF=@DIF; $IFhow="default" }}
if(not $OF) {
  if(defined $CFG{output}) { $OF=$CFG{output}[0]; $OFhow=$cfg }
  else			   { $OF=$DOF; $OFhow="default" }}

# ----------------------------------------------------------------------------------------------- NOW
our %NOW;
my @now = localtime;

$NOW{Y} = $now[5]+1900;
$NOW{M} = $now[4]+1;
$NOW{D} = $now[3];
$NOW{h} = $now[2];
$NOW{m} = 0; $NOW{m} = 30 if $now[1]>=30;
$NOW{s} = 0;

$NOW{Y} = $DY if defined $DY;
$NOW{M} = $DM if defined $DM;
$NOW{D} = $DD if defined $DD;
$NOW{h} = $Dh if defined $Dh;
$NOW{m} = $Dm if defined $Dm;
$NOW{s} = $Ds if defined $Ds;

my $nowM=$NOW{M}; $nowM="0$nowM" if $nowM<10;
my $nowD=$NOW{D}; $nowD="0$nowD" if $nowD<10;
my $nowh=$NOW{h}; $nowh="0$nowh" if $nowh<10;
my $nowm=$NOW{m}; $nowm="0$nowm" if $nowm<10;
my $nows=$NOW{s}; $nows="0$nows" if $nows<10;
verbose "default date","$NOW{Y}-$nowM-$nowD $nowh:$nowm$CK_:$nows$CD_";

# -------------------------------------------------------------------------------------- INPUT FORMAT
our %REIF; # regexes for input formats
our %VEIF; # verbose input formats
our %VIF;  # variables order array for input formats

# include common.pl parser.pl input-parser.pl output-parser.pl
input_parser;

# verbose
for(@IF) {
  verbose "input format",$VEIF{$_},"($IFhow)";
  verbose  "input regex",$REIF{$_} if $DEBUG }
verbose "output format",$OF,"($OFhow)";

# debug
if(0) { for my $k (keys %REIF) {
  print "$k $CK_->$CD_ $REIF{$k}\n";
  print "$VIF{$k}{$_}: $_\n" for sort {$VIF{$k}{$a}<=>$VIF{$k}{$b}} keys %{$VIF{$k}};
  exit }}

# ---------------------------------------------------------------------------------------------- MAIN
# include processor.pl

# process files
if(@FILE) {
  for my $file (@FILE) {
    my $handle;
    open $handle,"$file" or die "$file: $!";
    print process_line($_) while <$handle>;
    close $handle }}

# otherwise process STDIN
else {
  binmode  STDIN; STDIN->blocking(0);
  binmode STDOUT; STDOUT->autoflush(1);
  my $str;
  while(1) {
    my $buf; my $n = sysread STDIN,$buf,4096;
    sleep 0.1 if not defined $n; # nothing to read
    next      if not defined $n;
    last      if $n==0;	# EOF
    $str .= $buf;
    print process_line($&) while $str =~ s/^.*\n// }
  print process_line($str)."\n" if $str ne "" }

# --------------------------------------------------------------------------- R.Jaksa 2017,2024 GPLv3
