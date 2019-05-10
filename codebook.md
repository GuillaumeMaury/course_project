**dataframes**  
TRAIN  : merge of the "train" datasets  
TEST   : merge of the "test" datasets  
DATA   : merge of TRAIN and TEST  
DATA_SUBSET : a subset on the columns of DATA, corresponding to the "mean" and "standard deviation"-like variables  
HAR_AVERAGES  : the final "tidy" dataset asked in the course project  

**vectors**  
extracting_indices : the index vector allowing the subseting of DATA into DATA_SUBSET

**functions**  
I used essentially base package functions, along with dplyr and tidyr ones:

read.table()  
rbind()  
cbind()  
grep()  
names()  
left_join()  
gsub()    
gather()  
group_by()  
summarise()  
