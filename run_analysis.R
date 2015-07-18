## convert .txt files to tables
train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt") ## subject identifier
train_X <- read.table("UCI HAR Dataset/train/X_train.txt")  ## raw data
train_y <- read.table("UCI HAR Dataset/train/y_train.txt") ## activity

test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt")
test_X <- read.table("UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("UCI HAR Dataset/test/y_test.txt")

## merge observation tables & extract only mean and std dev (step 1 & 2)
obs <- rbind(test_X, train_X) ## combine observations 
headers <- read.table("UCI HAR Dataset/features.txt")
headers_clean <- headers[,2] ## column labels as list
colnames(obs) <- headers_clean ## set labels as descriptive headers

means <- obs[,grep("mean()", colnames(obs))] ## extracts all columns with "mean()" in the name
stds <- obs[,grep("std()", colnames(obs))] ## extracts all columns with "std()" in the name

## merge observation tables with subject and activity & give descriptive name (step 3 & 4)
act <- rbind(test_y,train_y) ## combine activites
act$V1[act$V1 == 1] <- "Walking" ## name activites 
act$V1[act$V1 == 2] <- "Walking Upstairs"
act$V1[act$V1 == 3] <- "Walking Downstairs"
act$V1[act$V1 == 4] <- "Sitting"
act$V1[act$V1 == 5] <- "Standing"
act$V1[act$V1 == 6] <- "Laying"
names(act) <- "Activity" ## set column name

subs <- rbind(test_subject, train_subject) ## combine subject lists
names(subs) <- "Subject" ## set column name

data <- cbind(subs,act,means,stds) ## combined data frame

## create independent tidy data set with the average of each variable for each activity and each subject (step 5)
mean_names <- names(means)
std_names <- names(stds)
measure_names <- c(mean_names, std_names) ## vector containing all column names of variables to be averaged

library(reshape2) ## initalizes library that allows for melt() and dcast()
dataMelt <- melt(data, id = c("Subject","Activity"), measure.vars = measure_names) 
answer <- dcast(dataMelt, Subject + Activity ~ variable, mean) ## creates data frame with the average of each variable for each activity and each subject
write.table(answer, file = "Tidy data.txt",row.name=FALSE)
