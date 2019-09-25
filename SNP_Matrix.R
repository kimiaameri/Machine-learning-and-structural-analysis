
argv <- commandArgs(trailingOnly = TRUE)
MergePath <- argv[1]
SnpEffPath <- argv[2]
SNPcoreMatrix <- argv[3]
SNP1<- read.csv(paste0(MergePath,"clean_cut_filtered_merge_snpEff1.ann.vcf.vcf"), header = TRUE, sep="\t",stringsAsFactors = F)
SNP2<- read.csv(paste0(MergePath,"clean_cut_filtered_merge_snpEff2.ann.vcf.vcf"), header = TRUE, sep="\t",stringsAsFactors = F)
SNP3<- read.csv(paste0(MergePath,"clean_cut_filtered_merge_snpEff3.ann.vcf.vcf"), header = TRUE, sep="\t",stringsAsFactors = F)
SNP3<- SNP3[,1:5] 

SNPa.Matrix<- rbind(SNP1,SNP2,SNP3)
listpos<- unique(SNPa.Matrix$POS)

#-----------------------
listsnp <- list.files(SnpEffPath)

l<-length(listsnp)
SNP.Matrix <- matrix(0,nrow=length(listpos),ncol=l+1)
SNP.Matrix[ ,1]<- listpos
listname<- gsub("cut_filtered",replacement = "",listsnp,  perl = T)
listnames<- gsub(".ann.vcf",replacement = "",listname,  perl = T)
rownames(SNP.Matrix)<- SNP.Matrix[,1]
colnames(SNP.Matrix) <- c("POS", listnames [1:l])
for (i in 2:l)
{
  k<- listsnp[i-1]
  intersection <- as.matrix(read.table(paste(SnpEffPath,k,sep=""),header=T,sep="\t",stringsAsFactors = F))
  mm<- intersect(as.numeric(intersection[,1]), as.numeric(SNP.Matrix[,1]))
  SNP.Matrix[rownames(SNP.Matrix)%in%mm,i] <-1
}
write.csv(SNP.Matrix, SNPcoreMatrix)



