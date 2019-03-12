#!/usr/bin/perl
use strict;
use warnings;
use Cwd;

use File::Find;
use File::Basename;

my ($in_rgx,$in_files,$simple,$matches,$cwd);
sub trim($) {
  my $string = shift;
  $string =~ s/[\r\n]+//g;
  $string =~ s/\s+$//;
  return $string;
}

                                      # 1: Get input arguments
if ($#ARGV == 0) {                    # *** ONE ARGUMENT *** (search pattern)
  ($in_rgx,$in_files,$simple) = ($ARGV[0],".",1);
}
elsif ($#ARGV == 1) {                 # *** TWO ARGUMENTS *** (search pattern + filename or flag)
  if (($ARGV[1] eq '-e') || ($ARGV[1] eq '-E')) { # extended
    ($in_rgx,$in_files,$simple) = ($ARGV[0],".",0);
  }
  else { # simple
    ($in_rgx,$in_files,$simple) = ($ARGV[0],$ARGV[1],1);
  }
}
elsif ($#ARGV == 2) {                 # *** THREE ARGUMENTS *** (search pattern + filename + flag)
  ($in_rgx,$in_files,$simple) = ($ARGV[0],$ARGV[1],0);
}
else {                                # *** HELP *** (either no arguments or more than three)
  print "Usage:  ".basename($0)." regexpattern [filepattern] [-E]\n\n" .
        "Hints:\n" .
        "*) If you need spaces in your pattern, put quotation marks around it.\n" .
        "*) To do a case insensitive match, use (?i) preceding the pattern.\n" .
        "*) Both patterns are regular expressions, allowing powerful searches.\n" .
        "*) The file pattern is always case insensitive.\n";
  exit;
}


if ($in_files eq '.') {               # 2: Output search header
  print basename($0).": Searching all files for \"${in_rgx}\"... (".(($simple) ? "simple" : "extended").")\n";
}
else {
  print basename($0).": Searching files matching \"${in_files}\" for \"${in_rgx}\"... (".(($simple) ? "simple" : "extended").")\n";
}


if ($simple) { print "\n"; }          # 3: Traverse directory tree using subroutine 'findfiles'

($matches,$cwd) = (0,cwd);
$cwd =~ s,/,\\,g;
find(\&findfiles, $cwd);

                                      
sub findfiles {                       # 4: Used to iterate through each result
  my $file = $File::Find::name;       # complete path to the file

  $file =~ s,/,\\,g;                  # substitute all / with \

  return unless -f $file;             # process files (-f), not directories
  return unless $_ =~ m/$in_files/io; # check if file matches input regex
                                      # /io = case-insensitive, compiled
                                      # $_ = just the file name, no path

                                      # 5: Open file and search for matching contents
  open F, $file or print "\n* Couldn't open ${file}\n\n" && return;

  if ($simple) {                      # *** SIMPLE OUTPUT ***
    while (<F>) {
      if (m/($in_rgx)/o) {            # /o = compile regex
                 # file matched!
          $matches++;
          print "---" .               # begin printing file header
          sprintf("%04d", $matches) . # file number, padded with 4 zeros
          "--- ".$file."\n";          # file name, keep original name
                                      # end of file header
        last;                         # go on to the next file
      }
    }
  }                                   # *** END OF SIMPLE OUTPUT ***
  else {                              # *** EXTENDED OUTPUT ***
    my $found = 0;                    # used to keep track of first match
    my $binary = (-B $file) ? 1 : 0;  # don't show contents if file is bin
    $file =~ s/^\Q$cwd//g;            # remove current working directory
                                      # \Q = quotemeta, escapes string

    while (<F>) {
      if (m/($in_rgx)/o) {            # /o = compile regex
                                      # file matched!
        if (!$found) {                # first matching line for the file
          $found = 1;
          $matches++;
          print "\n---" .             # begin printing file header
          sprintf("%04d", $matches) . # file number, padded with 4 zeros
          "--- ".uc($file)."\n";      # file name, converted to uppercase
                                      # end of file header
          if ($binary) {              # file is binary, do not show content
            print "Binary file.\n";
            last;
          }
        }
        print "[$.]".trim($_)."\n";   # print line number and contents
        #last;                        # uncomment to only show first line
      }
    }
  }                                   # *** END OF EXTENDED OUTPUT ***

  # 6: Close the file and move on to the next result
  close F;
}

#7: Show search statistics
print "\nMatches: ${matches}\n";

# Search Engine Source: http://www.adp-gmbh.ch/perl/find.html
# Rewritten by Christopher Hilding, Dec 02 2006
# Formatting adjusted to my liking by Rene Nyffenegger, Dec 22 2006
