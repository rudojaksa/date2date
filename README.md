# date2date

Line-by-line date/time reformatter for CSV/DAT/TXT/MD or other text files.
Find all date/time fields in the file that match the input format and reformat
them to the output format.

 1. Automatically constructs regex pattern for date/time matching.
 2. Apply it to every line of input data.
 3. Re-format the output.

### USAGE
```
date2date [OPTIONS] FILE [FILE2]... > OUTPUT_FILE
cat FILE | date2date [OPTIONS] > OUTPUT_FILE
```

### FORMAT

```
  s    second                 0  1 ... 59 (decimal too)
  ss   second two-digit      00 01 ... 59 (decimal too)
  ss.s one decimal place     00.0 00.1 ... 59.9
  m    minute                 0  1 ... 59
  mm   minute two-digit      00 01 ... 59
  h      hour                 0  1 ... 24
  hh     hour two-digit      00 01 ... 24
  D       day number          1  2 ... 31
  DD      day two-digit      01 02 ... 31
  M     month numerical       1  2 ... 12
  MM    month two-digit      01 02 ... 12
  Month month full name      January February ... December
  Mon   month three-letters  Jan Feb ... Dec
  MO    month two-letters    JA FE MR AP MY JN JL AU SE OC NV DE
  yyyy   year safe           1900 ... 2099 (only 19XX and 20XX)
Y/YYYY   year full           1999 2000 2001 ... (any from 1000 ... 9999)
  YY     year two-digit      99 00 01 ...
  Year   year                -3500 1999 100000 (any number)
  epoch epoch ten-digit      0000000000 1234567890 ... (decimal too)
  Epoch epoch                0 1234567890 ... (decimal too)
```

### CONFIG FILE

Configuration file `.date2date` has "key: value" syntax, hash `#` starts
comments.  Tilde `~` can be used instead of space.  Double-dot config
`..date2date` file is accepted in all subdirectories and home-directory config
`~/.date2date` is accepted globally for the user. Example:
   
```
input: M/D/YYYY YYYY/MM/DD  # 2/22/2022 2022/02/22
output: D~Mon~YYYY          # 22 Feb 2022
```

### LIST OF FORMATS

```
02/22/2022  MM/DD/YYYY  USA
22.02.2022  DD.MM.YYYY  EUR
2022-02-22  YYYY-MM-DD  ISO (ISO 8601, sort-safe)
9 Feb 2022  D~Mon~YYYY
February 22, 2022  "Month D, YYYY"
2022-02-22 22:22   "YYYY-MM-DD hh:mm"  ISO date plus time
02 Feb 2022,22:22  DD~Mon~YYYY,hh:mm   two fields from/for CSV
```

### EXAMPLE

Two CSV fields (date and time) to a single ISO field:

    date2date -i DD~Mon~YYYY,hh:mm -o YYYY-MM-DD~hh:mm file.csv

<br><div align=right><i>R.Jaksa 2017,2024</i></div>
