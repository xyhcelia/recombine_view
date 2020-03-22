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

library("gplots")
mydata<-read.table(opt$input,sep="\t",row.names=1)
mydata<-data.matrix(mydata)

mydist<-dist(mydata)
myclust<-hclust(mydist)
myh<-max(myclust$height)*0.25
print (myh)
groups<-cutree(myclust,h=myh)
write.table(groups,file=paste(opt$output,"groups.txt",sep="."),sep="\t",col.names=F,row.names=T)

pdf(paste(opt$output,"pdf",sep="."))
result<-heatmap.2(mydata,trace="none",density.info="none",Colv=NA,dendrogram="row",col=colorRampPalette(c("lemonChiffon","forestgreen")),breaks=(seq(from=-0.5,to=1.5,by=1)),main=opt$output,cexRow=0.8)
write.table(t(result$carpet),file=paste(opt$output,"hclust.txt",sep="."),sep="\t",col.names=F,row.names=T)
dev.off()
