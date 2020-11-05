setwd("/Users/ericduford/Rprojects/datacleaningcourse")

#checking for data directory and downloading file
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/cleaning_dataset.zip", method = "curl")

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

# set the data set directory (default: "UCI HAR Dataset", trailing slash required)
dataset.dir <- "./UCI HAR Dataset/"

#' Load subset of the full 'UCI HAR Dataset' function.
#' 
#' This function loads a subset of the full data set. The steps are:
#' - load features table selecting only the std/mean columns 
#' - load activities, assign descriptive labels (convert into a factor variable)
#' - load subjects
#' - filter the data table to select only mean and standard deviation columns
#' - load labels and levels to the activity column and convert it into a factor variable
#' - assign cleaned feature strings as column names for the feature measurements
#' - create feature table appending the activities and subjects columns
#'
#' @param dataset.subset name of the data subset (i.e. 'train' or 'test')
#'
#' @return clean data table object
load.data.subset <- function(dataset.subset) {
        
        if(!dir.exists(dataset.dir)) stop(sprintf("Data set directory not found: %s", dataset.dir))
        
        print(sprintf("loading data subset '%s'", dataset.subset))
        
        # helper function to load data table
        load.data.table <- function(file.name, column.names) 
                data.table::fread(paste0(dataset.dir, file.name), col.names = column.names)
        
        # helper function to create the data file path for the train/test subsets
        create.datafile.path <- function(dataset.item) sprintf("%1$s/%2$s_%1$s.txt", dataset.subset, dataset.item)
        
        # helper function to create clean feature column names (replace '-' by '.' and remove '()')
        create.clean.colname <- function(file.name) file.name <- gsub("-", ".", gsub("[()]", "", file.name))
        
        # load sdt/mean features from features file
        features.column.names <- c("featurenumber", "featurename")
        stdmean.features <- load.data.table("features.txt", features.column.names) %>% 
                filter(grepl("mean|std", featurename))
        
        # load activity levels and labels
        activity.labels <- load.data.table("activity_labels.txt", c("activity", "label"))
        
        # load activities and convert the vector into a factor variable using the activity table
        # levels: WALKING WALKING_UPSTAIRS WALKING_DOWNSTAIRS SITTING STANDING LAYING
        data.file.path.y <- create.datafile.path("y")
        activities <- (load.data.table(data.file.path.y, c("activity"))$activity)  %>%
                factor(levels=activity.labels$activity, labels=activity.labels$label)
        
        # load subjects and convert the vector to a factor variable with 
        # levels: 1 2 3 4 5 6
        data.file.path.subject <- create.datafile.path("subject")
        subjects <- load.data.table(data.file.path.subject, c("subject"))$subject %>% factor(levels = c(1:30))

        # create feature table including the following actions:
        # - load features table 
        # - select std/mean features
        # - assign cleaned column names (of selected features) 
        # - bind activity column
        # - move the last (binded) column to be the first one
        data.file.path.X <- create.datafile.path("X")
        result.table <- data.table::fread(paste0(dataset.dir,data.file.path.X)) %>%
                select(stdmean.features[["featurenumber"]]) %>%
                `colnames<-`( create.clean.colname(stdmean.features[["featurename"]]) ) %>%
                mutate(activity=activities, subject=subjects) %>%
                select(80:81, 1:79)
}

#' Function to merge the two data tables created for the 'train' and 'test' subsets.
#' 
#' @return In case of success the function returns the merged data table object.
create.clean.dataset <- function() {

        # load subset 'train'
        data.subset.train <- load.data.subset("train")

        # load subset 'test'
        data.subset.test <- load.data.subset("test")

        # merge data sets if they exist
        if(exists("data.subset.train") & exists("data.subset.test")) {
                print(sprintf("Merging 'train' data table (%d rows, %d columns) and 'test' data table (%d rows, %d columns)", 
                        nrow(data.subset.train), ncol(data.subset.train), nrow(data.subset.test), ncol(data.subset.test)))
                combined <- union(data.subset.test, data.subset.train)
                
        } else
                stop("Error: data set cannot be created.")
}

#' Function to create the data set file based on the clean data set table.
#'
#' @param clean.dataset clean data set
#' @param clean.dataset.file.name clean data set file name
create.clean.dataset.file <- function(clean.dataset, clean.dataset.file.name) {
        print(sprintf("Creating file for merged data table (%d rows, %d columns)", nrow(clean.dataset), ncol(clean.dataset)))
        if(exists("clean.dataset") ) 
                write.table(clean.dataset, clean.dataset.file.name, row.names = FALSE, quote = FALSE)
}

#' Function to create the tidy data set based on the clean data set.
#' 
#' @return In case of success the function returns the merged data table object.
create.tidy.dataset <- function(clean.dataset) {
        
        # id vars for melting the data set
        melt.id.vars = c("subject", "activity")
        
        # measurement column names (excluding the id vars)
        melt.measure.vars = colnames(clean.dataset)[!colnames(clean.dataset) %in% c("subject", "activity")]
        
        # meldted data
        melted.data = melt(clean.dataset, id = melt.id.vars, measure.vars = melt.measure.vars)
        
        # create data set for average of each measurement variable for each activity and subject
        dcast(melted.data, subject + activity ~ variable, mean)
}

#' Function to create the tidy data set file based on the clean data set table.
#'
#' @param clean.dataset clean data set
#' @param tidy.dataset.file.name tidy data set file name
create.tidy.dataset.file <- function(tidy.dataset, tidy.dataset.file.name) {
        tidy.dataset.file.name <- tidy.dataset.file.name
        write.table(tidy.dataset, tidy.dataset.file.name, row.names = FALSE, quote = FALSE)
}

# execute functions
clean.dataset <- create.clean.dataset()
clean.dataset.file.name <- "clean_dataset.txt"
create.clean.dataset.file(clean.dataset, clean.dataset.file.name)

# If the clean data set exists, create tidy data set 
if(exists("clean.dataset")) {
        tidy.dataset <- create.tidy.dataset(clean.dataset)
        print(sprintf("Clean data set file created: %s ", clean.dataset.file.name))
        # create tidy data set file
        tidy.dataset.file.name <- "tidy_dataset.txt"
        create.tidy.dataset.file(tidy.dataset, tidy.dataset.file.name)
        if(file.exists(tidy.dataset.file.name)) 
                print(sprintf("Tidy data set file created: %s ", tidy.dataset.file.name))
}