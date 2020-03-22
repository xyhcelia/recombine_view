rm(list=ls())
library("getopt")
spec <- matrix(
  c("input",  "i", 2, "character", "inputfile",
    "output", "o", 2, "character",  "output file prefix",
    "help",   "h", 0, "logical",  "This script is used to cluster snp pattern for a given region"),
  byrow=TRUE, ncol=5)

opt<-getopt(spec=spec)

if( !is.null(opt$help) || is.null(opt$input) || is.null(opt$output)){
      cat(paste(getopt(spec=spec, usage = T),"\n"))
      quit()
}

input<-read.table(opt$input,sep="\t")
nx=max(input[,3]);
ny=max(input[,4]);

pdf(paste(opt$output,"IBD_plot.pdf",sep="."))
plot(1,1,xlim=c(0,nx+20),ylim=c(0,ny+20),type="n",bty="n",xaxt="n",yaxt="n",ylab=NA,xlab=NA)
axis(1,1:nx)

for(i in 1:nrow(input)){
    arr<-strsplit(as.character(input[i,5]),',')
    col<-arr[[1]]
    mycol<-rgb(col[1],col[2],col[3])
    rect(xleft = input[i,2]-0.5, ybottom = input[i,4]-0.5, xright = input[i,3]+0.5, ytop = input[i,4]+0.5,col=mycol,border=NA)
    text(x =nx+5 , y = input[i,4], labels = input[i,1],cex=0.5)
}

dev.off()
