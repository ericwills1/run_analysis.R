Getting and Cleaning Data Course Projectless 
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement.
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names.
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


#load "y" activity and train data sets
testlabels <- read.table("test/Y_test.txt", header = FALSE)
trainlabels <- read.table("train/Y_train.txt", header = FALSE)

#load "x" activity and train data sets
testdata <- read.table("test/X_test.txt", header = FALSE)
traindata <- read.table("train/X_train.txt", header = FALSE)

#load subject data from test and train
testsubject <- read.table("test/subject_test.txt", header = FALSE)
trainsubject <- read.table("train/subject_train.txt", header = FALSE)

#combine "x", "y" and subject data sets
ydatalabels <- rbind(trainlabels, testlabels)
subject <- rbind(trainsubject, testsubject)
data <- rbind(traindata, testdata)
 
#change factor levels to match activity labels
labels <- read.table("activity_labels.txt", header = FALSE)
ydatalabels$V1 <- factor(ydatalabels$V1, levels = as.integer(labels$V1), labels = labels$V2)

#puts descriptive names for teh activity and subject data
names(ydatalabels) <- c("activity")
names(subject) <- c("subject")

#assigns descriptive names for the measurements by taking the names from the features file, the names are found in the #second column, named V2
featurestxt <- read.table("features.txt", head = FALSE)
names(data) <- featurestxt$V2
 
#selects colums with mean and std dev
meanstdev <- c(as.character(featurestxt$V2[grep("mean\\(\\)|std\\(\\)", featurestxt$V2)]))
subdata <- subset(data, select = meanstdev)

#combine data sets with activity and labels
subjectactivity <- cbind(subject, ydatalabels)
completedata <- cbind(subdata, subjectactivity)
 
#simplify time and frequency variables
names(completedata) <- gsub("^t", "time", names(completedata))
names(completedata)<- gsub("^f", "frequency", names(completedata))
 
#complete data set with means for subject and activity
finaldata <- aggregate(completedata, by = list(completedata$subject, completedata$activity), FUN = mean)

colnames(finaldata)[1] <- "Subject"
names(finaldata)[2] <- "Activity"

#finally it creates a tidy data set by aggregating all the mean() and std() values by taking the mean for each value grouped by activity and subject

tidydata <- aggregate(finaldata[1:68], by=tidydata[,67:68], FUN=MEAN)

write.table(tidydata, file = "tidydata.txt", row.name = FALSE)
