# Getting anfd Cleaning Data Course Project
library(dplyr)
library(reshape2)

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
activity_label <- read.table("activity_labels.txt")
names(activity_label) <- c("activity_id", "Activity")
names(y) <-c("activity_id")
activity <- merge(y, activity_label)

# read the subject data
subject_train <- read.table("subject_train.txt")
subject_test <- read.table("subject_test.txt")
subject <- rbind(subject_train, subject_test)
names(subject) <- c("subject_id")

# create IDs used for merge data frame
subject_id = data.frame(subject_id = 1:30)
ids <- merge(activity_label, subject_id, all=TRUE)
ids <- mutate(ids, id = subject_id*10 + activity_id )

# Combine the data, add another id column
data <- cbind(subject, activity, X)
data <- mutate(data, id = subject_id*10 + activity_id )

# Melt the data
dMelt <- melt(data, id=c("id"), measure.vars=feature_name)

#Cast back
result <- dcast(dMelt, id ~ variable, mean)

#Merge with subject 
result <- merge(ids, result, by.x="id", by.y="id")

result<-result[ ,c(4,3,5:83)]

#write the result to file
write.table(result, "results.txt", row.names = FALSE)

