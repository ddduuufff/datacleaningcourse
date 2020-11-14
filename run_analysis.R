setwd("/Users/ericduford/Rprojects/datacleaningcourse/data")

#checking for data directory and downloading file
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/cleaning_dataset.zip", method = "curl")

#Now let's unzip the file
unzip(zipfile = "./data/cleaning_dataset.zip", exdir = "./data")
#  You should create one R script called run_analysis.R that does the following.
#
#    1. Merges the training and the test sets to create one data set.
#    2. Extracts only the measurements on the mean and standard deviation for each measurement.
#    3. Uses descriptive activity names to name the activities in the data set
#    4. Appropriately labels the data set with descriptive variable names.
#    5. From the data set in step 4, creates a second, independent tidy data set with the average 
#    	of each variable for each activity and each subject.

# load required libraries
library(data.table)
library(dplyr)
library(reshape2)


# 1. Merge the training and test datasets

# Reading training datasets
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

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

#Final step is to merge all of the data into one data set
all_train <- cbind(y_train, subject_train, x_train)
all_test <- cbind(y_test, subject_test, x_test)
complete_dataset <- rbind(all_train, all_test)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.

#I tried using select() to just select the columns needed, but there are duplicate column names

#Let's get the column names to search against using grepl
column_names <- colnames(complete_dataset)

mean_and_std <- (grepl("activityID", colNames) | 
                 grepl("subjectID", colNames) |
                 grepl("mean..", colNames) | # This will get all of the columns containing mean
                 grepl("std...", colNames)  # This will get all of the columns containing standard deviation
		)

#This will subset the data to extract just the mean and std occurances 
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

