#----------------- Convert character matrix into numeric matrix----------------------#
library(ggfortify)
dataset<- apply(normalized.core, 2, as.numeric)
#---------------------- using PCA for feature selection ----------------------------#
pca<-prcomp(dataset[,1:(ncol(dataset)-1)], scale=TRUE)
summary.pca<- summary(pca)

#--------------------------- visulationg the PCA -----------------------------------#
library(factoextra)

fviz_eig(pca)
fviz_pca_ind(pca,
             col.ind = "label", # Color by the quality of representation
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)
fviz_pca_var(pca,
             col.var = "contrib", # Color by contributions to the PC
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)
fviz_pca_biplot(pca, repel = TRUE,
                col.var = "#2E9FDF", # Variables color
                col.ind = "#696969"  # Individuals color
)

plotdata<- as.data.frame(dataset) 
plotdata$label <- as.factor(plotdata$label)
plotpca<- autoplot(pca, data=plotdata, colour = "label" )
plotpca
importance.pca<- summary.pca$importance
Cumulative.pca<- sort(importance.pca[3,],decreasing = TRUE)
svminput<- cbind(pca$x, as.character(plotdata$label))
svminput<- apply(svminput, 2, as.numeric)

colnames(svminput)<- c(colnames(pca$x),"label")
#---------------------------------SVM ------------------------------#
#svminput$label = factor(svminput$label, levels = c(-1,0, 1)) 
# Splitting the dataset into the Training set and Test set 
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
#------------------- only s nad R

split = sample.split(factor(x.s[,"label1"], levels = c(0, 1)), SplitRatio = 0.75) 

training_set = subset(x.s, split == TRUE) 
test_set = subset(x.s, split == FALSE) 
#training_set[-ncol(training_set)] = scale(training_set[-ncol(training_set)]) 
#test_set[-ncol(test_set)] = scale(test_set[-ncol(test_set)])
x.s<- as.data.frame(x.s)
classifier = svm(formula = label1~., 
                 data = training_set, 
                 type = 'C-classification', 
                 kernel = 'linear') 

y_pred = predict(classifier, newdata = test_set[-ncol(test_set)]) 
cm = table(test_set[,ncol(test_set)], y_pred) 
cm



Acc<- which(test_set[,ncol(test_set)]==y_pred)
Accuracy<- (length(Acc)*100)/nrow(test_set)
Accuracy

# installing library ElemStatLearn 
library(ElemStatLearn) 

# Plotting the training data set results 
set = training_set 
X1 = seq(min(set[, 1]) - 1, max(set[, 1]) + 1, by = 0.01) 
X2 = seq(min(set[, 2]) - 1, max(set[, 2]) + 1, by = 0.01) 

grid_set = expand.grid(X1, X2) 
colnames(grid_set) = c('Age', 'EstimatedSalary') 
y_grid = predict(classifier, newdata = grid_set) 

plot(set[, -3], 
     main = 'SVM (Training set)', 
     xlab = 'Age', ylab = 'Estimated Salary', 
     xlim = range(X1), ylim = range(X2)) 

contour(X1, X2, matrix(as.numeric(y_grid), length(X1), length(X2)), add = TRUE) 

points(grid_set, pch = '.', col = ifelse(y_grid == 1, 'coral1', 'aquamarine')) 

points(set, pch = 21, bg = ifelse(set[, 3] == 1, 'green4', 'red3')) 

