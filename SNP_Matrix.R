
argv <- commandArgs(trailingOnly = TRUE)
#MergePath <- argv[1]
Pospath<- argv[1]
SnpEffPath <- argv[2]
Patric<- argv[3]
SNPcoreMatrix <- argv[4]
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


#------------------------adding class lable to each isolate
y <- colSums(SNP.Matrix)
x<- rowSums(SNP.Matrix)
plot(density(y))
z<-table(y)
cutoff<- which(x > (0.05* length(y)))
snp.without.rare.position <- SNP.Matrix[cutoff,]
#-------------------------------#
#   read input files            #
#-------------------------------#
sralist<- read.csv(paste0(Patric,"/count.amr.csv"), header = T, sep=" ")
genomelist<- read.csv(paste0(Patric,"/core.matrix.csv"), header = T, sep=",")
Patric<- read.csv(paste0(Patric,"/PATRIC_genome.csv"),sep=",", header = TRUE,stringsAsFactors=T)
Patric1<- read.csv(paste0(Patric,"/PATRIC_genome-3.csv"),sep=",", header = TRUE,stringsAsFactors=T)

AMR.list<- read.csv(paste0(Patric,"/PATRIC_genome_amr.csv"),sep=",", header = TRUE,stringsAsFactors=T)
#-------------------- find SRA list from Patric which have the AntiMicrobial Resistance type --------
lk<-which (Patric$SRA.Accession1 != "" | Patric$SRA.Accession2 != ""|Patric$SRA.Accession3 != ""
           |Patric$SRA.Accession4 != "" & Patric$AntiMicrobial.Resistance1!="" )
listdata<- Patric[lk,]
all.sra<- c(as.character(listdata$SRA.Accession1),as.character(listdata$SRA.Accession2)
            ,as.character(listdata$SRA.Accession3),as.character(listdata$SRA.Accession4))
#----------------------------Find the AntiMicrobial.Resistance type type for each genome --------------
corematrix<- t(snp.without.rare.position)

sralist<- rownames(corematrix)
ind <- sapply(sralist,function(sralist) grep(sralist,Patric1$SRA.Accession))

sra2resistance <- Patric1[ind,c(19,52)]
anyNA(sra2resistance)
#df<- as.data.frame(sra2resistance)
#df2<-within(df,SRA.Accession<- do.call('rbind',strsplit(as.character(SRA.Accession),',', fixed = TRUE)))
#df3<- as.matrix(df2)
#indd<-match(sralist,df2$SRA.Accession)
#ind1 <- sapply(sralist,function(sralist) grep(sralist,df2))

#anyNA(indd)

indd<-match(sralist,sra2resistance[,1])
indd1<- !is.na(indd)
label <- as.character(sra2resistance[indd1,2])
anyNA(label)


corematrix1 <- cbind(corematrix,label)
rownames(corematrix1)<- sralist
corematrix1<- corematrix1[complete.cases(corematrix1),]
antimicrobial.type<- as.numeric(ncol(corematrix1))

corematrix1[,antimicrobial.type]<- gsub("Intermediate;","",corematrix1[,antimicrobial.type]) 
corematrix1[,antimicrobial.type]<- gsub(";Intermediate","",corematrix1[,antimicrobial.type]) 
corematrix1[,antimicrobial.type]<- gsub("Susceptible;Resistant","Resistant;Susceptible",corematrix1[,antimicrobial.type]) 

corematrix1[,antimicrobial.type]<- gsub("Resistant;Susceptible","0",corematrix1[,antimicrobial.type]) 
corematrix1[,antimicrobial.type]<- gsub("Resistant","1",corematrix1[,antimicrobial.type]) 
corematrix1[,antimicrobial.type]<- gsub("Susceptible","-1",corematrix1[,antimicrobial.type]) 



corematrix1<- corematrix1 [-which(corematrix1[,antimicrobial.type] == "Intermediate"),]
table(corematrix1[,antimicrobial.type])
rownames(corematrix1)->isolates
              #------------------------------------------------------
y1<- corematrix1[-which(corematrix1[,antimicrobial.type]==0),]
x1<- x1[,-which(colSums(y1)==0)]
#-------------------------------------------------------
suseptible1.Samples<- x1[which(x1[,"label"]==-1),-ncol(x1)]
resistance1.Samples<- x1[which(x1[,"label"]==1),-ncol(x1)]
              
