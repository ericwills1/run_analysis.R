library(plyr)

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

#names activity and subject columns
names(ydatalabels) <- c("activity")
names(subject) <- c("subject")

#names feature columns from text file
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
names(completedata)<- gsub("Acc", "Accelerometer", names(completedata))
names(completedata)<- gsub("Gyro", "Gyroscope", names(completedata))
names(completedata)<- gsub("Mag", "Magnitude", names(completedata))
names(completedata)<- gsub("BodyBody", "Body", names(completedata))
 
#from the data set in step 4, create a second independent tidy data set with #the average of each variable for each activity and each subject.
finaldata <- ddply(completedata, .(subject, activity), function(x) colMeans(x[, 1:66]))

#complete data set with means for subject and activity
finaldata <- aggregate(completedata, by = list(completedata$subject, completedata$activity), FUN = mean)

write.table(finaldata, file = "tidydata.txt", row.name = FALSE)
