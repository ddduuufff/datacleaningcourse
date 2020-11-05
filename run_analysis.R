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

#Step 1: download and unzip the data
# Unzip dataSet to /data directory
unzip(zipfile="./data/cleaning_dataset.zip", exdir="./data")

#define the path where the new folder has been unziped
pathdata = file.path("./data/UCI HAR Dataset")
#create a file which has the 28 file names
files = list.files(pathdata, recursive=TRUE)
#show the files
files

#Step 2: extract the test and training sets to create one data set

        #test data set
        #train data set
        #features data set
        #activity labels data set



##  [1] "activity_labels.txt"                         
##  [2] "features.txt"                                
##  [3] "features_info.txt"                           
##  [4] "README.txt"                                  
##  [5] "test/Inertial Signals/body_acc_x_test.txt"   
##  [6] "test/Inertial Signals/body_acc_y_test.txt"   
##  [7] "test/Inertial Signals/body_acc_z_test.txt"   
##  [8] "test/Inertial Signals/body_gyro_x_test.txt"  
##  [9] "test/Inertial Signals/body_gyro_y_test.txt"  
## [10] "test/Inertial Signals/body_gyro_z_test.txt"  
## [11] "test/Inertial Signals/total_acc_x_test.txt"  
## [12] "test/Inertial Signals/total_acc_y_test.txt"  
## [13] "test/Inertial Signals/total_acc_z_test.txt"  
## [14] "test/subject_test.txt"                       
## [15] "test/X_test.txt"                             
## [16] "test/y_test.txt"                             
## [17] "train/Inertial Signals/body_acc_x_train.txt" 
## [18] "train/Inertial Signals/body_acc_y_train.txt" 
## [19] "train/Inertial Signals/body_acc_z_train.txt" 
## [20] "train/Inertial Signals/body_gyro_x_train.txt"
## [21] "train/Inertial Signals/body_gyro_y_train.txt"
## [22] "train/Inertial Signals/body_gyro_z_train.txt"
## [23] "train/Inertial Signals/total_acc_x_train.txt"
## [24] "train/Inertial Signals/total_acc_y_train.txt"
## [25] "train/Inertial Signals/total_acc_z_train.txt"
## [26] "train/subject_train.txt"                     
## [27] "train/X_train.txt"                           
## [28] "train/y_train.txt"

At this stage the file are now unipped and there entire data set is ready to be evaluated. There are 28 files and that need to be analyzed. Refer above.

Note - This is the basis for the entire project. Ensure that this milestone is reached.
Data Analysis

In the data the readme.me document, you will get a detailed perspective of what to expect and how to manipulate the data. There are three core variables:

        Main
        2. Test 3. Train

Main : activity_labels Inertial Signals Inertial Signals Test: features subject_test subject_train Train: features.info X_test X_train

README y_test y_train ‘features_info.txt’: Shows information about the variables used on the feature vector. * - ‘features.txt’: List of all features. * - ‘activity_labels.txt’: Links the class labels with their activity name. * - ‘train/X_train.txt’: Training set. * - ‘train/y_train.txt’: Training labels. * - ‘test/X_test.txt’: Test set. *- ‘test/y_test.txt’: Test labels

Analysis shows that you can categorize the data into 4 segments * training set * test set * features * activity labels

Inertial Signal data is not required. Additionally, features and activity label are more for tagging and descriptive than data sets.
Making the Test and Training Set Data

The objective here is to make the test and training data as per the sequence stated above. 4 basic level data sets will be defined and created:

        test data set
        train data set
        features data set
        activity labels data set

### 1.Making the test and training sets
xtrain = read.table(file.path(pathdata, "train", "X_train.txt"),header = FALSE)
ytrain = read.table(file.path(pathdata, "train", "y_train.txt"),header = FALSE)
subject_train = read.table(file.path(pathdata, "train", "subject_train.txt"),header = FALSE)
#Reading the testing tables
xtest = read.table(file.path(pathdata, "test", "X_test.txt"),header = FALSE)
ytest = read.table(file.path(pathdata, "test", "y_test.txt"),header = FALSE)
subject_test = read.table(file.path(pathdata, "test", "subject_test.txt"),header = FALSE)
#Read the features data
features = read.table(file.path(pathdata, "features.txt"),header = FALSE)
#Read activity labels data
activityLabels = read.table(file.path(pathdata, "activity_labels.txt"),header = FALSE)

### 2. Uses descriptive activity names to name the activities in the data set
#Create Sanity and Column Values to the Train Data
colnames(xtrain) = features[,2]
colnames(ytrain) = "activityId"
colnames(subject_train) = "subjectId"
#Create Sanity and column values to the test data
colnames(xtest) = features[,2]
colnames(ytest) = "activityId"
colnames(subject_test) = "subjectId"
#Create sanity check for the activity labels value
colnames(activityLabels) <- c('activityId','activityType')


###3. Merge the data sets
#Merging the train and test data - important outcome of the project
mrg_train = cbind(ytrain, subject_train, xtrain)
mrg_test = cbind(ytest, subject_test, xtest)
#Create the main data table merging both table tables - this is the outcome of 1
setAllInOne = rbind(mrg_train, mrg_test)


### 4. extracting mean and SD

# Need step is to read all the values that are available
colNames = colnames(setAllInOne)
#Need to get a subset of all the mean and standards and the correspondongin activityID and subjectID 
mean_and_std = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))
#A subtset has to be created to get the required dataset
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

### 5. Name data set
setWithActivityNames = merge(setForMeanAndStd, activityLabels, by='activityId', all.x=TRUE)


### 6. Name the data set
# New tidy set has to be created 
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]


### 7. Save the data
#The last step is to write the ouput to a text file 
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)