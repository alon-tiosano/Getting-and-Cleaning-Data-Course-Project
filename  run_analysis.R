#getting data#

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./Dataset.zip")
unzip(zipfile="./Dataset.zip",exdir="./Dataset.zip")

# reading data#
#trining#
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
#testing#
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

features <- read.table('./UCI HAR Dataset/features.txt')

activityLabels <- read.table('./UCI HAR Dataset/activity_labels.txt')

#setting names#

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

#merging data#

mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
All <- rbind(mrg_train, mrg_test)

colNamesnew <- colnames(All)

#selecting data#

mean_std <- ( grepl("mean" , colNamesnew) | grepl("std" , colNamesnew) | grepl("activityId" , colNamesnew) | grepl("subjectId" , colNamesnew) )


MeanStd <- All[ , mean_std == TRUE]


Activity_Names <- merge(MeanStd, activityLabels, by='activityId', all.x=TRUE)

# new data#

newdata <- aggregate(. ~subjectId + activityId, Activity_Names, mean)
newdata <- newdata[order(newdata$subjectId, newdata$activityId),]

write.table(newdata, "newdata.txt", row.name=FALSE)
