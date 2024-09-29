
# return zero padded 2-decimal integer
our sub d2dd {
  return "0$_[0]" if $_[0]<10;
  return "$_[0]" }

# return zero padded 4-decimal integer
our sub d2dddd {
  return "000$_[0]" if $_[0]<10;
  return "00$_[0]" if $_[0]<100;
  return "0$_[0]" if $_[0]<1000;
  return "$_[0]" }

# return zero padded 10-decimal integer
our sub d10d {
  return "$_[0]" if $_[0]>=1000000000;
  return "0$_[0]" if $_[0]>=100000000;
  return "00$_[0]" if $_[0]>=10000000;
  return "000$_[0]" if $_[0]>=1000000;
  return "0000$_[0]" if $_[0]>=100000;
  return "00000$_[0]" if $_[0]>=10000;
  return "000000$_[0]" if $_[0]>=1000;
  return "0000000$_[0]" if $_[0]>=100;
  return "00000000$_[0]" if $_[0]>=10;
  return "000000000$_[0]" if $_[0]>=0;
  return "$_[0]" }

