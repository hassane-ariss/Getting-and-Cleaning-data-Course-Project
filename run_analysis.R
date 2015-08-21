## This script is used to process the raw data sets collected under 
## the Human Activity Recognition.
## it's outpu is a tidy data that can be used for later analysis.
# Loading the reshape2 
library(reshape2)

## Loading test and training datasets 
test.subject <- read.table("./test/subject_test.txt")
test.x <- read.table("./test/X_test.txt")
test.y <- read.table("./test/y_test.txt")
train.subject <- read.table("./train/subject_train.txt")
train.x <- read.table("./train/X_train.txt")
train.y <- read.table("./train/y_train.txt")
## Loading  common datasets
features <- read.table("./features.txt")
activity.labels <- read.table("./activity_labels.txt")



# 1- Merges the training and the test sets to create one data set.

# Merge the test and training x dataset
ds <- rbind(test.x, train.x)

# Using the features names to name the features measurment. 
colnames(ds) <- features[, 2]


# 2- Extracts only the measurements on the mean and standard deviation for each measurement. 
meanstd <- grep("-mean|-std", names(ds))
narrowds <- ds[,meanstd]


# 3- Uses descriptive activity names to name the activities in the data set

activity <- rbind(test.y, train.y)
activity <- merge(activity, activity.labels, by=1)[,2]

# 4- Appropriately labels the data set with descriptive variable names. 

# Merging test and training subject datasets
subject <- rbind(test.subject, train.subject)
colnames(subject) <- "Subject"

# Merge subject , activity and features measurements into a single data set
# with corresponding descriptive names
allds <- cbind(subject,activity,narrowds)


# 5- Creates an independent tidy data set with the average of each variable for each activity and each subject.

melted <- melt(allds,id.vars = c("Subject","activity"))
tidy <- dcast(melted,Subject + activity ~ variable,mean)

# Write the tidy data to output file
write.table(tidy, file="./tidy.txt",row.names = FALSE)