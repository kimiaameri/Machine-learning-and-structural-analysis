argv <- commandArgs(trailingOnly = TRUE)
InputPath <- argv[1]
OutputFile <- argv[2]


listdata<- list.files(InputPath)
listdata<- gsub(pattern = "filtered_",replacement = "",listdata, perl = T)
z1<- gsub(pattern = '_([1-9]+).*',replacement = "",listdata, perl = T)

z<-unique(z1)
inputFile<- matrix(NA, ncol=3, nrow=length(z))
inputFile[,1]<- z
#listdata<- unique(listdata)
even_indexes<-seq(2,length(listdata),2)
odd_indexes<-seq(1,length(listdata),2)

for (i in 1:length(z))
{
  if ( i %% 2== 1) {inputFile[i,2]<- as.matrix(as.character(listdata[odd_indexes[i]]))
  inputFile[i,3]<- as.matrix(as.character(listdata[even_indexes[i]]))}
  
  if ( i %% 2== 0) {inputFile[i,2]<- as.matrix(as.character(listdata[odd_indexes[i]]))
  inputFile[i,3]<- as.matrix(as.character(listdata[even_indexes[i]]))}
}
colnames(inputFile)<- c("SrA.Accession","Forward reads", "Reverse Reads")
#write.table(inputFile, OutputFile, col.names = F, row.names = F , quote=FALSE)
#write.table(m, OutputFile, col.names = F, row.names = F , quote=FALSE)
write.csv(inputFile, OutputFile, row.names = F)
