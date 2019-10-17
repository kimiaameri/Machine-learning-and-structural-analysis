#----------------- Convert character matrix into numeric matrix----------------------#
library(ggfortify)
dataset<- apply(normalized.core, 2, as.numeric)
#---------------------- using PCA for feature selection ----------------------------#
pca<-prcomp(dataset[,1:(ncol(dataset)-1)], scale=TRUE)
summary.pca<- summary(pca)
svminput<- cbind(pca$x, as.character(plotdata$label))
svminput<- apply(svminput, 2, as.numeric)

colnames(svminput)<- c(colnames(pca$x),"label")
set.seed(123000) 

inx<- c(sample(which(svminput[,"label"]==1),0.75* length(y)),
        which(svminput[,antimicrobial.type]==-1),
        which(svminput[,antimicrobial.type]==1))


split = sample.split(factor(svminput[,"label"], levels = c(-1,0, 1)), SplitRatio = 0.75) 

training_set = subset(svminput, split == TRUE) 
test_set = subset(svminput, split == FALSE) 
#training_set[,-ncol(training_set)] = scale(training_set[,-ncol(training_set)]) 
#test_set[,-ncol(test_set)] = scale(test_set[,-ncol(test_set)])
# Fitting SVM to the Training set 
svminput<- as.data.frame(svminput)

#training_set1<- as.matrix(training_set)
classifier = svm(formula = label~., 
                 data = training_set, 
                 type = 'C-classification', 
                 kernel = 'radial') 


# Predicting the Test set results 
y_pred = predict(classifier, newdata = test_set[,-ncol(test_set)]) 


# Making the Confusion Matrix 
cm = table(test_set[,ncol(test_set)], y_pred) 
cm
Acc<- which(test_set[,ncol(test_set)]==y_pred)
Accuracy<- (length(Acc)*100)/nrow(test_set)
Accuracy
