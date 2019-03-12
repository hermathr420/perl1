#!/usr/bin/perl
use strict;
use warnings;
 
use DBI;
# MySQL database configuration
my $dsn = "DBI:mysql:pet";
my $username = "root";
my $password = 'ming6mow';
 
# connect to MySQL database
my %attr = ( PrintError=>0,  # turn off error reporting via warn()
             RaiseError=>1);   # turn on error reporting via die()           
 
my $dbh  = DBI->connect($dsn,$username,$password, \%attr);
 
