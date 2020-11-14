# data_cleaning_course
Getting and Cleaning Data course from Coursera
Summary

This project allows creating a "clean" data set from the 'UCI HAR Dataset' available at:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The script merges different subsets of this data into a tidy dataset

Before executing the script the data set must be unzipped and set in the proper working directory using 'setwd' R command.

Execute the R script in the working directory, ./data, where the 'UCI HAR Dataset' folder is located


The script will create the result data files "tidy_dataset.txt" in the working directory.

The script uses the following R libraries which need to be installed:

    data.table
    dplyr
    reshape2

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average 
	of each variable for each activity and each subject.



# 1. Merge the training and test datasets

# Reading training datasets

# Reading test datasets
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Reading the feature vector
features <- read.table("./data/UCI HAR Dataset/features.txt")
       
# Reading activity labels
activityLabels = read.table("./data/UCI HAR Dataset/activity_labels.txt")
 
# This is skipping ahead to step 4 but let's assign variable names now before we merge the data sets

# Training variable names
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityID"
colnames(subject_train) <- "subjectID"

# Test variable names
colnames(x_test) <- features[,2]
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"

colnames(activityLabels) <- c("activityID", "activityType")

# Final step is to merge all of the data into one data set
all_train <- cbind(y_train, subject_train, x_train)
all_test <- cbind(y_test, subject_test, x_test)
complete_dataset <- rbind(all_train, all_test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

# I tried using select() to just select the columns needed, but there are duplicate column names

# Let's get the column names to search against using grepl
column_names <- colnames(complete_dataset)

mean_and_std <- (grepl("activityID", colNames) | 
                 grepl("subjectID", colNames) |
                 grepl("mean..", colNames) | # This will get all of the columns containing mean
                 grepl("std...", colNames)  # This will get all of the columns containing standard deviation
		)

# This will subset the data to extract just the mean and std occurances 
mean_std_extracted <- complete_dataset[ , mean_and_std == TRUE]


# 3. Uses descriptive activity names to name the activities in the data set
# Let's do this by merging the activity labels to our extracted data
activity_names_added <- merge(mean_std_extracted, activityLabels,
                                      by = "activityID",
                                      all.x = TRUE)

# 4. Appropriately labels the data set with descriptive variable names.
# This has already completed throughout the script

# 5. From the data set in step 4, creates a second, independent tidy data set with the average 
# 	of each variable for each activity and each subject.

tidy_data <- activity_names_added %>% 
	group_by(activityID, subjectID, activityType) %>%
	summarize_each(funs(mean)) 

# write the table to txt file
write.table(secTidySet, "tidy_data.txt", row.name=FALSE)

