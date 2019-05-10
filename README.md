# Getting and cleaning data course project - from original HAR data set in a zip to a tidy data set

Author : Guillaume Maury Date : May 10th 2019

## Contents
* README markdown file
* codebook markdown file
* run_analysis.R file : the R script

## Note  
The dataset files of the project (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) first have to be loaded in your working directory BEFORE running the script.

## Description of the script in 5 steps
#### 1. MERGE 
 First cbind() the "train" files together with subject and activity columns on the left in a big "TRAIN" file, respectively the "test" files in a big "TEST" file, then rbind() the "TRAIN" and "TEST" dataframes together in a "DATA" dataframe

### 2. EXTRACT Mean and Standard Deviation measures
I will use grep() with features.txt to tag ALL "Mean"- and "Standard Deviation"-like measures.The resulting vector "extracting_indices" then allows a subsetting operation on the columns of DATA... of course, I add +2 to each index of this vector, because now DATA has 563 variables instead of 561 before, since I've added a "subject" and an "activity" (not properly renamed yet) column to the original dataframes.... AND I keep the 2 first columns, which contain the subject and activity informations.
              
### 3. NAME ACTIVITIES
The second column of DATA describes the activities, but it is coded 1 to 6. activity_labels.txt gives the plain English translation, so I use a left_join() function to re-code the "activity" column.
  
### 4. LABEL THE VARIABLE NAMES
I re-write the 86 "mean" or "std" variable names from the "features" dataframe in plain English with the help of features.txt and gsub

### 5.TIDY DATASET WITH AVERAGE FOR EACH VARIABLE, ACTIVIY AND SUBJECT
I create a 4 columns dataframe from DATA_SUBSET, which gives the average of each variable, grouped by activity, grouped by subject : subject, activity, variable_names, average.
