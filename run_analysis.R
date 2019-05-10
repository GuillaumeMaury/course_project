# 1. MERGE ---------------------------------------------------------

library(dplyr)
library(tidyr)

features<-read.table("features.txt")
activity_labels<-read.table("activity_labels.txt")
subject_train<-read.table("subject_train.txt")
subject_test<-read.table("subject_test.txt")
X_train<-read.table("X_train.txt")
y_train<-read.table("y_train.txt")
X_test<-read.table("X_test.txt")
y_test<-read.table("y_test.txt")

TRAIN<-cbind(subject_train,y_train,X_train)
TEST<-cbind(subject_test,y_test,X_test)
DATA<-rbind(TRAIN,TEST)

# 2. EXTRACT Mean and Standard Deviation measures --------------------

extracting_indices<-grep("mean|std",features$V2,ignore.case=TRUE,value=FALSE)

# Creation of DATA_SUBSET from a subset on the columns of DATA: 
DATA_SUBSET<-(DATA[,c(1,2,extracting_indices+2)])
              
# 3. NAME ACTIVITIES ------------------------------------------------

names(DATA_SUBSET)[c(1,2)]<-c("subject","activity_code")
names(activity_labels)<-c("activity_code","activity")

# The last column of DATA_SUBSET will give the activity names in plain English
DATA_SUBSET<-left_join(DATA_SUBSET,activity_labels,by="activity_code")

# 4. LABEL THE VARIABLE NAMES ---------------------------------------------

variable_names <- features[extracting_indices,2] %>% 
  gsub("^t","time_",.) %>% 
  gsub("^f","frequency_",.) %>%
  gsub("Acc","_linear_acceleration_",.) %>% 
  gsub("Mag","_magnitude",.) %>%
  gsub("Jerk","_Jerk_signal_",.) %>% 
  gsub("Gyro","_angular_velocity_",.) %>% 
  gsub("tBody","time_body",.)
    
  names(DATA_SUBSET)[3:88]<- variable_names
                     
# 5.TIDY DATASET WITH AVERAGE FOR EACH VARIABLE, ACTIVIY AND SUBJECT ---------------------------------------------
 
HAR_AVERAGES <- DATA_SUBSET  %>%  
  gather("variable","value",3:88) %>% 
  group_by(subject,activity,variable) %>% 
  summarise("average"=mean(value)) %>%
  write.table(file="HAR_AVERAGES.txt",sep=" ",col.names=TRUE)
