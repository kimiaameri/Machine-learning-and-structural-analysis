
argv <- commandArgs(trailingOnly = TRUE)
#MergePath <- argv[1]
Pospath<- argv[1]
SnpEffPath <- argv[2]
SNPcoreMatrix <- argv[3]
#SNP1<- read.csv(paste0(MergePath,"clean_merge_snpEff1.ann.vcf"), header = TRUE, sep="\t",stringsAsFactors = F)
#SNP2<- read.csv(paste0(MergePath,"clean_merge_snpEff2.ann.vcf"), header = TRUE, sep="\t",stringsAsFactors = F)
#SNP3<- read.csv(paste0(MergePath,"clean_merge_snpEff3.ann.vcf"), header = TRUE, sep="\t",stringsAsFactors = F)
#SNP3<- SNP3[,1:5] 

#SNPa.Matrix<- rbind(SNP1,SNP2,SNP3)
listpos<- read.csv(paste0(Pospath,"uniq.pos.txt"),header=F,sep="\t",stringsAsFactors = F)

#-----------------------
listsnp <- list.files(SnpEffPath , pattern= "vcf")
l<-length(listsnp)

SNP.Matrix <- matrix(0,nrow=nrow(listpos),ncol=l)
listname<- gsub("filtered",replacement = "",listsnp,  perl = T)
listnames<- gsub(".ann.vcf",replacement = "",listname,  perl = T)
colnames(SNP.Matrix) <-  listnames 
rownames(SNP.Matrix) <- listpos[,1]

for (i in 1:l)
{  
  print(i)
  k = listsnp[i]
  intersection <- as.matrix(read.table(paste(SnpEffPath,k,sep=""),header=T,sep="\t",stringsAsFactors = F))
  mut.pos <- as.numeric(intersection[,1])
  SNP.Matrix[as.character(mut.pos),i] <- 1
  print(i)
}
write.csv(SNP.Matrix, SNPcoreMatrix)



