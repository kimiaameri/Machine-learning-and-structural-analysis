argv <- commandArgs(trailingOnly = TRUE)
sourcePath <- argv[1]
OutputFile<- argv[2]
SNP1<- read.csv( paste0(sourcePath,"/clean_cut_filtered_merge_snpEff1.ann.vcf.vcf"), header = TRUE, sep="\t")
SNP2<- read.csv(paste0(sourcePath,"/clean_cut_filtered_merge_snpEff2.ann.vcf.vcf", header = TRUE, sep="\t")
SNP3<- read.csv(paste0(sourcePath,"/clean_cut_filtered_merge_snpEff3.ann.vcf.vcf", header = TRUE, sep="\t")

SNP1.Matrix<- merge(x=SNP1, y=SNP2, all = TRUE, by="POS")
for (i in 1: nrow(SNP1.Matrix))
 if (is.na (SNP1.Matrix[i,]$REF.x ))
  { 
  SNP1.Matrix[i,]$REF.x <- as.character(SNP1.Matrix[i,]$REF.y)
  SNP1.Matrix[i,]$ALT.x<- as.character(SNP1.Matrix[i,]$ALT.y)
  SNP1.Matrix[i,]$QUAL.x <-  as.character(SNP1.Matrix[i,]$QUAL.y)
  SNP1.Matrix[i,]$INFO.x <- as.character(SNP1.Matrix[i,]$INFO.y)
  
}
SNP1.Matrix <- SNP1.Matrix [,1:5]
SNP.Matrix<- merge( x=SNP1.Matrix, y=SNP3, all = TRUE, by="POS")

for (i in 1: nrow(SNP.Matrix))
  if (is.na (SNP.Matrix[i,]$REF.x ))
  { 
    SNP.Matrix[i,]$REF.x <- as.character(SNP.Matrix[i,]$REF)
    SNP.Matrix[i,]$ALT.x<- as.character(SNP.Matrix[i,]$ALT)
    SNP.Matrix[i,]$QUAL.x <-  as.character(SNP.Matrix[i,]$QUAL)
    SNP.Matrix[i,]$INFO.x <- as.character(SNP.Matrix[i,]$INFO)
    
  }
SNP.Matrix <- SNP.Matrix [,1:5]
write.csv(SNP.Matrix,OutputFile)
