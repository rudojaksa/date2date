{ # INPUT FORMAT PARSER FOR DATE2DATE
  # require parser.pl

# input is freed once taken, i.e. Y can be used only once "Y Y" should match "2022 Y", like "Y \Y"
my $FOUND=""; # list of found names: "yyyy|YYYY|YY"...
my %TAKEN=(); # whether the type was already taken, so it can be freed from further matching
my @HIDEN=(); # stored strings for replacement in the input format string
my $hi;	      # current index in @HIDEN
my $str;      # current input format string

# parse($variable_type,$variable_name,$regex) $_[0]=q $_[1]="Y" $_[2]="yyyy" $_[3]=qr/19\d\d|20\d\d/
# type: Y=year M=month D=day h=hour m=month s=sec e=epoch (once Y is taken no further year search is done)
my sub parse {
  my ($type,$name,$re) = @_;
  # print STDERR "$type: $name <- $re [$str]\n"; # print all names considered
  return if $TAKEN{$type};
  if($REIF{$str} =~ s/$name/$STX$hi$ETX/) {	# find the name in the REIF
    $HIDEN[$hi++] = qr/($re)/;			# 
    $TAKEN{$type} = 1 }				# 
  # print STDERR "$type: $name <- $re\n\n" if $TAKEN{$type}; # print only these taken by input formats
  return if not $TAKEN{$type};
  $VEIF{$str} =~ s/$name/$CC_$name$CD_/;	# find and mark the name int the VEIF
  $FOUND .= "$name|" } # add the name to the order

# globals: @IF=input %REIF=output %VIF=output
our sub input_parser {
  for(@IF) {					# here str becomes "global" current IFmt string
    $str = $_;					# global variable, used as key
    my $qstr = quotemeta $str;			# local, used to parse
    my $vstr = $str;
    $FOUND=""; %TAKEN=();			# these are input-pattern specific too
    @HIDEN=(); $hi=0;				# replaced stored text, current index

    # hide escapes \Y,\M,\D,... (in qstr these are already quotemeta, so two double backslash)
    while($qstr=~s/\\\\([YyMDhmseE~])/$STX$hi$ETX/) { $HIDEN[$hi++]=$1 }
    while($vstr=~  s/\\([YyMDhmseE~])/$STX$hi$ETX/) { $HIDEN[$hi++]=$1 }

    # replace ~ by spaces
    $qstr =~ s/\\~/ /g;
    $vstr =~ s/\~/ /g;

    $REIF{$str} = $qstr;			# regex to build
    $VEIF{$str} = $vstr;			# verbose msg to build
    # prtx "1",$REIF{$str};

    # find the input format variable parts and replace them by appropriate regex group string
    # the order must be parsing-safe i.e. YYYY before YY and Year before Y

    parse "Y","yyyy",qr/19\d\d|20\d\d/;
    parse "Y","YYYY",qr/\d{4}/;
    parse "Y","YY",qr/\d\d/;
    parse "Y","Year",qr/-?\d+/;
    parse "Y","Y",qr/\d{4}/;			# the same as YYYY

    parse "M","Month",qr/January|February|March|April|May|June|July|August|September|October|November|December/;
    parse "M","Mon",qr/Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec/;
    parse "M","MO",qr/JA|FE|MR|AP|MY|JN|JL|AU|SE|OC|NV|DE/;
    parse "M","MM",qr/01|02|03|04|05|06|07|08|09|10|11|12/;
    parse "M","M",qr/1|2|3|4|5|6|7|8|9|10|11|12/;

    parse "D","DD",qr/01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31/;
    parse "D","D",qr/1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31/;

    parse "e","Epoch",qr/\d{1,10}/;		# epoch any
    parse "e","epoch",qr/\d{10}/;		# epoch ten digit

    parse "h","hh",qr/0\d|1\d|2[0-4]/;		# permissive allows "24"
   #parse "h","hx",qr/\d|1\d|2[0-3]/;		# strict "01" forbidden, "24" forbidden
    parse "h","h",qr/\d|[01]\d|2[0-4]/;		# permissive allows "24" and "01" too

    parse "m","mm",qr/[0-5]\d|60/;		# permissive allows "60"
   #parse "m","mx",qr/\d|[1-5]\d/;		# strict "01" forbidden, "60" forbidden
    parse "m","m",qr/\d|[0-5]\d|60/;		# permissive allows "60" and "01" too

   #parse "s","sss",qr/[0-5]\d|60/;		# permissive allows "60", decimal optional, any number of places
    parse "s","ss.ss",qr/[0-5]\d\.\d\d|60\.00/; # permissive allows "60.00"
    parse "s","ss.s",qr/[0-5]\d\.\d|60\.0/;	# permissive allows "60.0"
    parse "s","ss",qr/[0-5]\d|60/;		# permissive allows "60"
   #parse "s","sx",qr/\d|[1-5]\d/;		# strict "01" forbidden, "60" forbidden
    parse "s","s",qr/\d|[0-5]\d|60/;		# permissive allows "60" and "01" too

    # unescape
    # prtx "2",$REIF{$str}; prtx "2",$VEIF{$str};
    while($REIF{$str}=~s/$STX([0-9]+)$ETX/$HIDEN[$1]/) {}
    while($VEIF{$str}=~s/$STX([0-9]+)$ETX/$HIDEN[$1]/) {}
    # prtx "3",$REIF{$str}; prtx "3",$VEIF{$str};

    # identify the order of format variable parts (regex groups)

    $FOUND =~ s/\|$//; # print STDERR "--> $FOUND\n";
    my $z = $str; # copy
    my $i = 0; # which re group ($1,$2,...) holds YYYY,MM.. =0 so the %VIF starts with index 0 
    $VIF{$str}{$1}=$i++ while $z=~s/($FOUND)// }} # one-by-one remove them and note the $i

} # R.Jaksa 2017,2024 GPLv3
