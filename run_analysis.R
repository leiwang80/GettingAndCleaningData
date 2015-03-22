# Getting anfd Cleaning Data Course Project
library(dplyr)

# Read the data from text file to data frame
# X_test.txt
# X_train.txt
# activity_labels.txt
# features.txt
# run_analysis.R
# subject_test.txt
# subject_train.txt
# y_test.txt
# y_train.txt

# read the feature file
feature_all = read.table("features.txt")

# the vector of feature name
feature_name_all = feature_all[,2]

# row index related to mean
mean_index = grep("mean()",feature_name_all )

# row index related to mean
std_index = grep("std()",feature_name_all )

# feature related to mean and std only
feature = filter(feature_all, V1 %in% c(mean_index, std_index))

# related feature index and name
feature_index = feature$V1
feature_name = feature$V2

# read the X_train, X_test only save the related column to frame
X_train = read.table("X_train.txt")[,feature_index]
X_test = read.table("X_test.txt")[,feature_index]
X = rbind(X_train, X_test)
X = na.omit(X)

# assign feature names
names(X) = feature_name

# read y data for train and test, and combine them into one frame 
y_train = read.table("y_train.txt")
y_test = read.table("y_test.txt")
y = rbind(y_train, y_test)

# read activity_label data 
# create activity data from y data by merge
activity_label = read.table("activity_labels.txt")
activity = merge(y, activity_label, by.x="V1", by.y="V1")[,2]
names(activity) = c("Activity")

# read the subject data
subject_train = read.table("subject_train.txt", colClasses = "factor")
subject_test = read.table("subject_test.txt", colClasses = "factor")
subject = rbind(subject_train, subject_test)
names(subject) = c("Subject")

# Combine the data
data = cbind(subject, activity, X)






