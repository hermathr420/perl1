#!/usr/bin/perl
use strict;
use warnings;
use v5.10; # for say() function
 
use DBI;
 
say "Perl MySQL Create Table Demo";
 
# MySQL database configurations
my $dsn = "DBI:mysql:perlmysqldb";
my $username = "root";
my $password = '';
 
# connect to MySQL database
my %attr = (PrintError=>0, RaiseError=>1);
 
my $dbh = DBI->connect($dsn,$username,$password, \%attr);
 
# create table statements
my @ddl =     (
 # create tags table
 "CREATE TABLE tags (
 tag_id int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
 tag varchar(255) NOT NULL
         ) ENGINE=InnoDB;",
        # create links table
        "CREATE TABLE links (
   link_id int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
   title varchar(255) NOT NULL,
   url varchar(255) NOT NULL,
   target varchar(45) NOT NULL
 ) ENGINE=InnoDB;",
 # create link_tags table
 "CREATE TABLE link_tags (
   link_id int(11) NOT NULL,
   tag_id int(11) NOT NULL,
   PRIMARY KEY (link_id,tag_id),
   KEY fk_link_idx (link_id),
   KEY fk_tag_idx (tag_id),
   CONSTRAINT fk_tag FOREIGN KEY (tag_id) 
      REFERENCES tags (tag_id),
   CONSTRAINT fk_link FOREIGN KEY (link_id) 
 REFERENCES links (link_id) 
 ) ENGINE=InnoDB"
        );
 
# execute all create table statements	       
for my $sql(@ddl){
  $dbh->do($sql);
}        
 
say "All tables created successfully!";
 
# disconnect from the MySQL database
$dbh->disconnect();
