#!/usr/bin/perl
use strict;
use Getopt::Long;
use File::Basename;
use vars qw( $input $output $ordfile $lseed $mis $min  @ids @seq @order $dir);

#####default values####
$lseed=10;
$mis=1;
$min=30;

GetOptions(
   "h|help"=>\&USAGE,
   "i=s"=>\$input,
   "o=s"=>\$output,
   "l=i"=>\$lseed,
   "N=i"=>\$mis,
   "m=i"=>\$min,
   "ord=s"=>\$ordfile,
) or USAGE();


sub USAGE{
my $usage=<<EOF;
Usage:perl $0  -i input  -o output
-h|--help:    print manual
-i:  input snp file
-o:  prefix for output files
-l:  seed length(default:10)
-N:  mismatch allowed in a seed(default:1)
-m:  minimum  acceptable length for a  descent(IBD) region(default:30)
-ord(optional): this parameter accept a file appointing the order for query of IBD searching	
Denpendency:
R
Format example for the snp file:
CBS10459        1       0       0       0       1       0       1       0  1
CBS10460        0       0       0       0       0       0       0       0  1
CBS10468        0       0       0       0       0       0       0       0  1
CBS2775 0       0       0       1       0       0       0       0       1
CBS356  0       0       0       0       0       0       0       0       1
CBS357  0       0       0       1       0       0       0       0       1
CBS5682 0       0       0       0       0       0       0       0       1
DY15504 1       0       0       0       1       0       1       0       1
DY15505 1       0       0       0       1       0       1       0       1
DY29150 0       0       0       0       0       0       0       0       1
EOF
print $usage;
exit;
}

$dir=dirname(__FILE__);

#####clustring using Rscript#####
`Rscript $dir/scripts/snp_hclust.R -i $input  -o $output`;

open IN,"<$output.hclust.txt";
while(<IN>){
    chomp;
    my @arr=split;
    $arr[0]=~s/"//g;
    push(@ids,$arr[0]);
    push(@seq,join("",@arr[1..$#arr]));
}
close IN;

#######reorder  @ids#######
if(defined($ordfile)){
    open ORD,"<$ordfile";
    while(<ORD>){
        chomp;
        push(@order,$_);
    }     
    close ORD;
}else{
    my %grpnum;
    open NUM,"cat $output.groups.txt|cut -f 2|sort|uniq -c|";
    while(<NUM>){
        my @arr=split;
        $grpnum{$arr[1]}=$arr[0];
    }
    close NUM;
  
    open GRP,"<$output.groups.txt";
    open OUTNUM,">$output.groups.num.txt";
    while(<GRP>){
        chomp;
        my @arr=split;
        $arr[0]=~s/"//g;
        print OUTNUM "$arr[0]\t$arr[1]\t$grpnum{$arr[1]}\n";
    } 
    close GRP;
    close OUTNUM;
    
    open GRPNUM,"cat $output.groups.num.txt|sort -k3,3nr -k2,2n -k1,1|";
    while(<GRPNUM>){
        chomp;
        my @arr=split;
        push(@order,$arr[0]);
    }
    close GRPNUM;
    `rm $output.groups.num.txt`;
}
`rm $output.groups.txt`;

for my$i(0..$#ids){
    open BED,">$output.$ids[$i].bed";
    for my $j(0..$#ids){
        my $n=1;
        my $count;
        while($n<=length($seq[$i])-$lseed+1){
             my $seed1=substr($seq[$i],$n-1,$lseed);
             my $seed2=substr($seq[$j],$n-1,$lseed);
             my $iden=`perl $dir/scripts/string_compare.pl $seed1 $seed2`;
             if($iden>=1-$mis/$lseed){
                $count++;
                $n++;
             }else{
                if($count>=$min-$lseed+1){
                    print BED "$ids[$j]\t",$n-$count-1,"\t",$n+$lseed-2,"\t$ids[$i]-like\n";
                }
                $count=0;
                $n++;
            }
        }
        if($count>=$min-$lseed+1){
            print BED "$ids[$j]\t",$n-$count-1,"\t",$n+$lseed-2,"\t$ids[$i]-like\n";
        }

    }
    close BED;
}

`cat $output.$order[0].bed |awk '{print \$1\"\t\"\$2+1\"\t\"\$3\"\t\"\$4;}' >$output.tmp0`;
`rm $output.$order[0].bed`;
for my $n2(1..$#order){
      my $n1=$n2-1;
      ` perl $dir/scripts/extract_nooverlap.pl $output.$order[$n2].bed  $output.tmp$n1 |awk '{if(\$2>0 && \$3>=\$2) print \$0;}'|cat $output.tmp$n1 - >$output.tmp$n2`;
      `rm $output.tmp$n1  $output.$order[$n2].bed`;
}

`mv $output.tmp$#ids $output.IBD.txt`;

my %no;
for my$i(0..$#ids){
   $no{$ids[$i]}=$i+1;
}

my %col;
open IBD,"<$output.IBD.txt";
open OUT,">$output.IBD.forplot.txt";
while(<IBD>){
    chomp;
    my @arr=split;
    if(exists($col{$arr[3]})){
        print OUT "$arr[0]\t$arr[1]\t$arr[2]\t$no{$arr[0]}\t$col{$arr[3]}\n"; 
    }else{
        $col{$arr[3]}=rand(1).",".rand(1).",".rand(1);
        print OUT "$arr[0]\t$arr[1]\t$arr[2]\t$no{$arr[0]}\t$col{$arr[3]}\n";
    }
}
close IBD;
close OUT;

`Rscript $dir/scripts/IBD.plot.R -i $output.IBD.forplot.txt -o $output`;
`rm $output.IBD.forplot.txt`;
