{ # PROCESSOR
  # require parser.pl
  # include epoch2time.pl
  # globals %REIF %VIF %NOW $COLOR

my %Month2M = ("January",1,"February",2,"March",3,"April",4,"May",5,"June",6,"July",7,"August",8,"September",9,"October",10,"November",11,"December",12);
my %Mon2M = ("Jan",1,"Feb",2,"Mar",3,"Apr",4,"May",5,"Jun",6,"Jul",7,"Aug",8,"Sep",9,"Oct",10,"Nov",11,"Dec",12);
my %MO2M = ("JA",1,"FE",2,"MR",3,"AP",4,"MY",5,"JN",6,"JL",7,"AU",8,"SE",9,"OC",10,"NV",11,"DE",12);

my $color;
   $color=$CC_ if $COLOR eq "C";
   $color=$CR_ if $COLOR eq "R";
   $color=$CG_ if $COLOR eq "G";
   $color=$CK_ if $COLOR eq "K";
   $color=$CW_ if $COLOR eq "W";

our sub process_line {
  my $line=$_[0]; # line to process
  my $out="";	  # output line
  my %REP;	  # replaced dates
  my $i=0;	  # their indexes
  # print STDERR "--> [$line]\n";

  # for every input date format
  for my $if (@IF) {
  # print STDERR "    [$if]\n";

    # for every match of given input date format on given line
    while($line =~ s/(?<=^|$MAR)$REIF{$if}(?=$|$MAR)/$STX$i$ETX/) {
      my @f = ($1,$2,$3,$4,$5,$6,$7); # Y M D h m s e <- max 7 fields in the match
      my      ($Y,$M,$D,$h,$m,$s);    # 6 time variables
      my $N = $VIF{$if}; # reference to the subhash for current $if

      # init with current date/time
      ($Y,$M,$D,$h,$m,$s) = ($NOW{Y},$NOW{M},$NOW{D},$NOW{h},$NOW{m},$NOW{s});

      # epoch time overrides init, but will be overriden with Y/M/D...
      my $epoch;
      $epoch = $f[$N->{Epoch}]	if defined $N->{Epoch};
      $epoch = $f[$N->{epoch}]	if defined $N->{epoch};
      ($Y,$M,$D,$h,$m,$s) = epoch2time $epoch if defined $epoch;

      # order by precision, 1st less precise / less permissive
      $Y = $f[$N->{YY}]+1900	if defined $N->{YY} and $x[$N->{YY}]>=$NOW{Y}+10;
      $Y = $f[$N->{YY}]+2000	if defined $N->{YY} and $x[$N->{YY}]<$NOW{Y}+10;
      $Y = $f[$N->{Year}]	if defined $N->{Year};
      $Y = $f[$N->{Y}]		if defined $N->{Y};
      $Y = $f[$N->{YYYY}]	if defined $N->{YYYY};
      $Y = $f[$N->{yyyy}]	if defined $N->{yyyy};

      $M = $f[$N->{M}]		if defined $N->{M};
      $M = $f[$N->{MM}]+0	if defined $N->{MM};
      $M = $MO2M{$f[$N->{MO}]}	if defined $N->{MO};
      $M = $Mon2M{$f[$N->{Mon}]} if defined $N->{Mon};
      $M = $Month2M{$f[$N->{Month}]} if defined $N->{Month};

      $D = $f[$N->{D}]		if defined $N->{D};
      $D = $f[$N->{DD}]+0	if defined $N->{DD};

      $h = $f[$N->{h}]		if defined $N->{h};
      $h = $f[$N->{hh}]+0	if defined $N->{hh};

      $m = $f[$N->{m}]		if defined $N->{m};
      $m = $f[$N->{mm}]+0	if defined $N->{mm};

      $s = $f[$N->{s}]		if defined $N->{s};
      $s = $f[$N->{ss}]+0	if defined $N->{ss};

      # print STDERR "     $Y $M $D \n";
      # prtx "1",$line;

      $REP{$i++} = output_parser $Y,$M,$D,$h,$m,$s }}

  if($COLOR) { $line =~ s/$STX$_$ETX/$color$REP{$_}$CD_/ for keys %REP }
  else	     { $line =~ s/$STX$_$ETX/$REP{$_}/ for keys %REP }

  return $line }

} # R.Jaksa 2017,2024 GPLv3
