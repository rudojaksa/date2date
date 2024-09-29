
our sub epoch2time {
  my $epoch = $_[0];
  my $isutc = $_[1];
  my ($Y,$M,$D,$h,$m,$s);

  if($isutc) { ($s,$m,$h,$D,$M,$Y) = (gmtime($epoch))[0,1,2,3,4,5] }
  else       { ($s,$m,$h,$D,$M,$Y) = (localtime($epoch))[0,1,2,3,4,5] }
  $Y += 1900;
  $M += 1;

  return $Y,$M,$D,$h,$m,$s }

