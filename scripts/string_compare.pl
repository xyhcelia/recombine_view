#!/usr/bin/perl
use strict;

if(@ARGV!=2){die "Usage:perl $0 string1 string2\n";}

my $string1=$ARGV[0];
my $string2=$ARGV[1];

my $short;
my $long;
if(length($string1)<=length($string2)){
    $short=length($string1);
    $long=length($string2);
}else{
    $short=length($string2);
    $long=length($string1);
}


my $match=0;
for my$i(1..$short){
    my$x1=substr($string1,$i-1,1);
    my$x2=substr($string2,$i-1,1);
    if($x1 eq $x2){
        $match++;
    }else{
    }
}
print $match/$long,"\n";
