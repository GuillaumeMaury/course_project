## Getting and cleaning data course project - from original HAR data set in a zip to a tidy data set

After reading the README.txt file in the HAR Samsung dataset very carefully : it appears that **it is not necessary to work with the files in the "Inertial Signals" subdirectories**

## 1. MERGE 
Which files should be merged together ? I suppose all the Samsung files have already been downloaded in the working directory.
So to explore the data I load them in R, with read.table since these are .txt files

I explore the data either with dim() or with the global environment panel of Rstudio : it confirms which files to merge with which files, and also the method. The "test" dataframes have the same number of rows : 2947 observations, so they could be merged together. The "train" ones have 7352 observations, and so on.

In which way (row- or column-wise) should they be merged ? First cbind() the "train" files together with subject and activity columns on the left in a big "TRAIN" file, respectively the "test" files in a big "TEST" file, then rbind() the "TRAIN" and "TEST" dataframes together in a "DATA" dataframe

## 2. EXTRACT Mean and Standard Deviation measures
a. Features_info.txt explains the different variable types contained in the dataset. And the assignment underlines this : I have to select ONLY the measurements on the mean and standard deviation for each measurement.
I assume that the extraction should include also the "meanFreq()" and "angle()" variables since they are explicitly described as MEANS.

b. So I will use grep() with features.txt to tag ALL "Mean"- and "Standard Deviation"-like measures.

c. The resulting vector "extracting_indices" then allows a subsetting operation on the columns of DATA... of course, I add +2 to each index of this vector, because now DATA has 563 variables instead of 561 before, since we've added a "subject" and an "activity" (not properly renamed yet) column to the original dataframes.
... AND we keep the 2 first columns, which contain the subject and activity informations.
              
## 3. NAME ACTIVITIES
The second column of DATA describes the activities, but it is coded 1 to 6. 
Fortunately, activity_labels.txt gives the plain English translation, so we will use a left_join() function to re-code the "activity" column.
But in order to work, the left_join first needs a bit renaming

## 4. LABEL THE VARIABLE NAMES
a. Re-write the 86 "mean" or "std" variable names from the "features" dataframe in plain English with the help of features.txt and gsub
b. Replace the 86 default column names with tidy_labels

## 5.TIDY DATASET WITH AVERAGE FOR EACH VARIABLE, ACTIVIY AND SUBJECT
I create a 4 columns dataframe from DATA_SUBSET, which gives the average of each variable, grouped by activity, grouped by subject : subject, activity, variable_names, average. 
The "magic" function here is 'r gather(data,key,value,...)', which gathers columns into rows.
