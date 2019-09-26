
argv <- commandArgs(trailingOnly = TRUE)
#MergePath <- argv[1]
Pospath<- argv[1]
SnpEffPath <- argv[2]
SNPcoreMatrix <- argv[3]
listpos<- read.csv(paste0(Pospath,"uniq.pos.txt"),header=F,sep="\t",stringsAsFactors = F)
#-----------------------
listsnp <- list.files(SnpEffPath , pattern= "vcf")
l<-length(listsnp)

SNP.Matrix <- matrix(0,nrow=nrow(listpos),ncol=l)
listnames<- gsub(".ann.vcf",replacement = "",listsnp,  perl = T)
colnames(SNP.Matrix) <-  listnames 
rownames(SNP.Matrix) <- listpos[,1]
for (i in 1:l)
{  
  k = listsnp[i]
  intersection <- as.matrix(read.table(paste(SnpEffPath,k,sep=""),header=T,sep="\t",stringsAsFactors = F))
  mut.pos <- as.numeric(intersection[,1])
  SNP.Matrix[as.character(mut.pos),i] <- 1
}
write.csv(SNP.Matrix, SNPcoreMatrix)



