{ # OUTPUT FORMAT PARSER FOR DATE2DATE
  # include time2epoch.pl

my @Month = ("","January","February","March","April","May","June","July","August","September","October","November","December");
my @Mon = ("","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
my @MO = ("","JA","FE","MR","AP","MY","JN","JL","AU","SE","OC","NV","DE");

my @HIDEN=(); # stored strings for replacement in the input format string
my $hi;	      # current index in @HIDEN
my $str;      # current output string

# parse($variable_name,$current_value) $_[0]="yyyy" $_[1]="2023"
my sub parse { $HIDEN[$hi++]=$_[1] while $str=~s/$_[0]/$STX$hi$ETX/ }

our sub output_parser {
  my ($Y,$M,$D,$h,$m,$s) = @_; # day/month/year/hour/minute/second
  # print STDERR "-> $Y-$M-$D $h:$m:$s\n";

  my $YYYY = d2dddd $Y;
  my $YY = d2dd $Y; $YY=$1 if $Y=~/([0-9][0-9])$/;

  $str=$OF; @HIDEN=(); $hi=0;

  # hide escapes \Y,\M,\D,...
  while($str=~s/\\([YyMDhmseE~])/$STX$hi$ETX/) { $HIDEN[$hi++]=$1 }

  # replace ~ by spaces
  $str =~ s/\~/ /g;

  parse "yyyy",$YYYY;
  parse "YYYY",$YYYY;
  parse "YY",$YY;
  parse "Year",$Y;
  parse "Y",$Y; # not YYYY here

  parse "Month",$Month[$M];
  parse "Mon",$Mon[$M];
  parse "MO",$MO[$M];
  parse "MM",d2dd($M);;
  parse "M",$M;

  parse "DD",d2dd($D);
  parse "D",$D;

  parse "Epoch",time2epoch($Y,$M,$D,$h,$m,$s);
  parse "epoch",d10d(time2epoch($Y,$M,$D,$h,$m,$s));

  parse "hh",d2dd($h);
  parse "h",$h;

  parse "mm",d2dd($m);
  parse "m",$m;

  parse "ss",d2dd($s);
  parse "s",$s;

  while($str=~s/$STX([0-9]+)$ETX/$HIDEN[$1]/) {}
  return $str }

} # R.Jaksa 2017,2024 GPLv3
