#This is the code book for the project

About the source data

The source data are from the Human Activity Recognition Using Smartphones Data Set. A full description is available at the site where the data was obtained: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones Here are the data for the project: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
About R script

R File: "run_analysis.R" performs has 5 steps:

    Reading in the files and merging the training and the test sets to create one data set.
   1. Merges the training and the test sets to create one data set.
   2. Extracts only the measurements on the mean and standard deviation for each measurement.
   3. Uses descriptive activity names to name the activities in the data set
   4. Appropriately labels the data set with descriptive variable names.
   5. From the data set in step 4, creates a second, independent tidy data set with the average 
   	of each variable for each activity and each subject.

Variables:
   Data from downloaded files: x_train, y_train, x_test, y_test, subject_train and subject_test
   Merged data: x_data, y_data and subject_data
    
