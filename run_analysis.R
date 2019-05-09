# I have written this script in order to follow strictly the instructions given 
# for the course project. So, it has 5 steps. I used a Mac OS X Sierra, 
# with R version 3.6.0 released on 2019/04/26

# After reading the README.txt file in the HAR Samsung dataset very carefully :
#it appears that it is not necessary to work with the files in the "Inertial Signals" subdirectories


# 1. MERGE ---------------------------------------------------------

library(dplyr)
library(tidyr)

# a. I suppose all the Samsung files have already been downloaded in the working directory.
# So to explore the data I load them in R, with read.table since these are .txt files

features<-read.table("features.txt")
activity_labels<-read.table("activity_labels.txt")
subject_train<-read.table("subject_train.txt")
subject_test<-read.table("subject_test.txt")
X_train<-read.table("X_train.txt")
y_train<-read.table("y_train.txt")
X_test<-read.table("X_test.txt")
y_test<-read.table("y_test.txt")

# e. Explore the data either with dim() or with the global environment panel of Rstudio :
# it confirms which files to merge with which files, and also the method.
# The "test" dataframes have the same number of rows : 2947 observations, so 
# they could be merged together. The "train" ones have 7352 observations, and so on.

# f. Merge : first cbind() the "train" files together with subject and activity columns on the left
#in a big "TRAIN" file, respectively the "test" files in a big "TEST" file,
# then rbind() the "TRAIN" and "TEST" dataframes together in a "DATA" dataframe

TRAIN<-cbind(subject_train,y_train,X_train)
TEST<-cbind(subject_test,y_test,X_test)
DATA<-rbind(TRAIN,TEST)

# 2. EXTRACT Mean and Standard Deviation measures --------------------

# a. Interpretation. Features_info.txt explains the different variable types
# contained in the dataset. And the assignment underlines this : I have to select ONLY
# the measurements on the mean and standard deviation for each measurement.
# I assume that the extraction should include also the "meanFreq()" and "angle()"
# variables since they are explicitly described as MEANS.

# b. So I will use grep() with features.txt to tag ALL "Mean"- and "Standard Deviation"-like measures.

extracting_indices<-grep("mean|std",features$V2,ignore.case=TRUE,value=FALSE)

# c. The resulting vector "extracting_indices" then allows a subsetting operation 
# on the columns of DATA... of course, I add +2 to each index of this vector,
# because now DATA has 563 variables instead of 561 before, 
# since we've added a "subject" and an "activity" (not properly renamed yet) column 
# to the original dataframes.
# ... AND we keep the 2 first columns, which contain the subject and activity informations.

DATA_SUBSET<-(DATA[,c(1,2,extracting_indices+2)])
              
# 3. NAME ACTIVITIES ------------------------------------------------

# The second column of DATA describes the activities, but it is coded 1 to 6. 
# Fortunately, activity_labels.txt gives the plain English translation, 
# so we will use a left_join() function to re-code the "activity" column.
# But in order to work, the left_join first needs a bit renaming

names(DATA_SUBSET)[c(1,2)]<-c("subject","activity_code")
names(activity_labels)<-c("activity_code","activity")

DATA_SUBSET<-left_join(DATA_SUBSET,activity_labels,by="activity_code")

# 4. LABEL THE VARIABLE NAMES ---------------------------------------------

# a. Re-write the 86 "mean" or "std" variable names from the "features" dataframe in plain English with the help of features.txt and gsub

variable_names <- features[extracting_indices,2] %>% 
  gsub("^t","time_",.) %>% 
  gsub("^f","frequency_",.) %>%
  gsub("Acc","_linear_acceleration_",.) %>% 
  gsub("Mag","_magnitude",.) %>%
  gsub("Jerk","_Jerk_signal_",.) %>% 
  gsub("Gyro","_angular_velocity_",.) %>% 
  gsub("tBody","time_body",.)
    
# b. Replace the 86 default column names with tidy_labels
                     
names(DATA_SUBSET)[3:88]<- variable_names # or names(DATA_SUBSET)[-c(1:2)]<- variable_names
                     
# 5.TIDY DATASET WITH AVERAGE FOR EACH VARIABLE, ACTIVIY AND SUBJECT ---------------------------------------------

# we are going to create a 4 columns dataframe from DATA_SUBSET, which gives the average of each variable, grouped by activity, grouped by subject :
# subject, activity, variable_names, average
 
HAR_AVERAGES <- DATA_SUBSET  %>%  
  gather("variable","value",3:88) %>% 
  group_by(subject,activity,variable) %>% 
  summarise("average"=mean(value)) %>%
  View