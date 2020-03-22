# recombine_view.pl
##### This script is used for visualizing recombination,introgression among individuals and calling break points according to snp information of a given region.

Recombination and introgression are major driving forces for genome evolution. In addition to the scientific importance of these two processes, they sometimes interfere with other genetic analyses.For example phylogenetic relationship inference,haplotype network construction and so on. So an tool efficiently visualizing the recombination situation of your genomic data will be helpful to be more cautious for the following analysis. 

Usage
-
``` 
perl recombine_view.pl  -i input  -o output  
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
CBS10460        0       0       0       0       0       0       0       0  1  
CBS10468        0       0       0       0       0       0       0       0  1  
CBS2775 0       0       0       1       0       0       0       0       1  
CBS356  0       0       0       0       0       0       0       0       1  
CBS357  0       0       0       1       0       0       0       0       1  
CBS5682 0       0       0       0       0       0       0       0       1  
DY15504 1       0       0       0       1       0       1       0       1  
DY15505 1       0       0       0       1       0       1       0       1  
DY29150 0       0       0       0       0       0       0       0       1 
```
#### SNP heatmap  
![image](https://github.com/xyhcelia/Readme_images/blob/master/recombine_view/tdk1_flank100snp_heatmap.jpg)  

#### Recombination visulization result by recombine_view.pl
![image](https://github.com/xyhcelia/Readme_images/blob/master/recombine_view/tdk1_introgression.jpg)
