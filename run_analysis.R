setwd("/Users/leclipse/git/cleaning_data/getdata/")
library('plyr')

# load datafile
trainSet = read.table(file="./UCI\ HAR\ Dataset/train/X_train.txt")
trainLabel = read.table(file="./UCI\ HAR\ Dataset/train/Y_train.txt")
trainSubject = read.table(file="./UCI HAR Dataset/train/subject_train.txt")

testSet = read.table(file="./UCI\ HAR\ Dataset/test/X_test.txt")
testLabel = read.table(file="./UCI\ HAR\ Dataset/test/Y_test.txt")
testSubject = read.table(file="./UCI HAR Dataset/test/subject_test.txt")

variableName = read.table(file="./UCI HAR Dataset/features.txt")
activity_label = read.table(file="./UCI HAR Dataset/activity_labels.txt")

# merge testset
set = rbind(trainSet, testSet)
colnames(set) <- variableName$V2

# extract only mean and std
set = set[grep("*-mean\\(\\)|*-std\\(\\)", names(set))]

# bind activity
label = rbind(trainLabel, testLabel)
label = merge(label, activity_label, by.x="V1", by.y="V1", all=TRUE)
colnames(label) <- c("activity", "activity name")
set = cbind(set, label)

# bind subject
subject = rbind(trainSubject, testSubject)
colnames(subject) <- c("subject")
set = cbind(set, subject)

# create tidy_set
tidy_set = ddply(set, c("subject", "activity"), function (x) colMeans(x[1:(length(set)-3)]))

# Write tidy_dataset.csv, with header
write.table(tidy_set, "tidy_set.csv")