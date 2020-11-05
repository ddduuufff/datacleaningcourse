# data_cleaning_course
Getting and Cleaning Data course from Coursera
Summary

This project allows creating a "clean" data set from the 'UCI HAR Dataset' available at:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

It merges different subsets of this data into one single transformed data set --- named "clean" data set --- in order to allow performing data analysis tasks more easily. As an example, a derived data set --- named "tidy" data set) --- is created which contains the average values of each measurement variable for each activity and each subject.
Run

Before executing the script please make sure the data set is unzipped in the working directory and set the working directory using the 'setwd' R command).

Then execute the R script in the working directory where the 'UCI HAR Dataset' folder is located:

run_analysis.R

The script will create the result data files "clean_dataset.txt" and "tidy_dataset.txt" in the working directory.

More concretely, the script executes the following steps:

    Load the individual data files of the training and test sets and merge them into one data table.
    Filter the data table to select only mean and standard deviation columns.
    Load labels and levels of the activity column and convert the variable into a factor variable.
    Assign cleaned feature strings as column names for the feature measurements.
    Merge test and training subsets into one final cleaned data set.
    Create another derived data set with average values of each measurement variable for each activity and each subject.

Dependencies

The script uses the following R libraries which need to be installed:

    data.table
    dplyr
    reshape2

Functions

load.data.subset

The function loads a subset of the full 'UCI HAR Dataset' (i.e. "train" and "test" subsets).

    The function loads a subset of the full data set. The steps are: ** load features table selecting only the std/mean columns ** load activities, assign descriptive labels (convert into a factor variable) ** load subjects ** filter the data table to select only mean and standard deviation columns ** load labels and levels to the activity column and convert it into a factor variable ** assign cleaned feature strings as column names for the feature measurements ** create feature table appending the activities and subjects columns

create.clean.dataset

Function to merge the two data tables created for the 'train' and 'test' subsets.

    Parameters: requires indicating the name of the data subset (i.e. 'train' or 'test') as parameter.
    Returns: clean data table object.

create.clean.dataset.file

Function to create the data set file based on the clean data set table.

    Parameters: clean data set table object, clean data set file name.
    Returns: none.
    Output: clean data set file "clean_dataset.txt"

create.tidy.dataset

Function to create the tidy data set based on the clean data set.

    Parameters: requires the clean dataset table object.
    Returns: tidy data table object.

create.tidy.dataset.file

Function to create the tidy data set file based on the clean data set table.

    Parameters: tidy data set table object, tidy data set file name.
    Returns: none.
    Output: tidy data set file "tidy_dataset.txt"
