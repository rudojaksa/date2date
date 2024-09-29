use Time::Local 'timelocal_nocheck';
use Time::Local 'timegm_nocheck';

sub time2epoch {
  my $y = $_[0];
  my $m = $_[1];
  my $d = $_[2];
  my $H = $_[3];
  my $M = $_[4];
  my $S = $_[5];
  my $isutc = $_[6];

  my $input = sprintf "%d-%02d-%02d %02d:%02d:%02d",$y,$m,$d,$H,$M,$S;
  $input .= "Z" if $isutc;

  # corrections
  my $c=0; # flag: whether corrected
  while($H>=24) { $H-=24; $d++; $c=1; } 
  my $correct = sprintf "%d-%02d-%02d %02d:%02d:%02d",$y,$m,$d,$H,$M,$S;
  $correct .= "Z" if $isutc;

  # localtime
  my $epoch;
  if($isutc) {
    $epoch = timegm_nocheck($S,$M,$H,$d,$m-1,$y); }
  else {
    $epoch = timelocal_nocheck($S,$M,$H,$d,$m-1,$y); }

  $input .= " -> $correct" if $c;
  #debug "epoch","$input -> $epoch";
  return $epoch; }

