########################################################################
# This script deals with course project of "getting an cleanning data"
# 1.Merges the training and the test sets to create one data set.
# 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3.Uses descriptive activity names to name the activities in the data set
# 4.Appropriately labels the data set with descriptive variable names. 
# 5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
########################################################################
# step 1. Merges the training and the test sets to create one data set.
# step 4. Appropriately labels the data set with descriptive variable names.
########################################################################
 x_test<-read.table("./data/UCI HAR Dataset/test/x_test.txt");
 y_test<-read.fwf("./data/UCI HAR Dataset/test/y_test.txt",widths=2);
 subject_test<-read.fwf("./data/UCI HAR Dataset/test/subject_test.txt",widths=2);
 colnames(subject_test)<-"subject";
 colnames(y_test)<-"activitylabel";


 x_train<-read.table("./data/UCI HAR Dataset/train/x_train.txt");
 subject_train<-read.fwf("./data/UCI HAR Dataset/train/subject_train.txt",widths=2);
 y_train<-read.fwf("./data/UCI HAR Dataset/train/y_train.txt",widths=2);
 colnames(y_train)<-"activitylabel";
 colnames(subject_train)<-"subject";
 

 

vars<-read.table("./data/UCI HAR Dataset/codebook.txt",header=T); #read variable names from codebook.txt;
vars1<-vars[1:561,3]; #subset variable names for feature1-feature561;
colnames(x_test)<-vars1;
colnames(x_train)<-vars1;
flag<-rep("test",2947);
testData<-cbind(flag,subject_test,y_test,x_test);
flag<-rep("train",7352)
trainData<-cbind(flag,subject_train,y_train,x_train);
HARdata<-rbind(trainData,testData);



#########################################################################################
# step 2. Extracts only the measurements on the mean and standard deviation for each measurement.

#########################################################################################
MeanStd<-HARdata[,c(1:9, 44:49, 84:89, 124:129, 164:169, 204, 205, 217, 218, 230, 231, 243, 244, 257, 258, 269:274, 297:299, 348:353, 376:378, 427:432, 455:457, 506, 507, 519, 520, 532, 533, 542, 545, 546, 555, 559:564)]
write.table(MeanStd,file="./data/UCI HAR Dataset/HARdata_mean&std.txt");


#########################################################################################
# step 3. Uses descriptive activity names to name the activities in the data set
#########################################################################################

a1<-HARdata[which(HARdata$activitylabel==1),];
a2<-HARdata[which(HARdata$activitylabel==2),];
a3<-HARdata[which(HARdata$activitylabel==3),];
a4<-HARdata[which(HARdata$activitylabel==4),];
a5<-HARdata[which(HARdata$activitylabel==5),];
a6<-HARdata[which(HARdata$activitylabel==6),] ;  
a1$activity<-"WALKING";
a2$activity<-"WALKING_UPSTAIRS";
a3$activity<-"WALKING_DOWNSTAIRS";
a4$activity<-"SITTING";
a5$activity<-"STANDING";
a6$activity<-"LAYING";
HARdata<-rbind(a1,a2,a3,a4,a5,a6);

write.table(HARdata,file="./data/UCI HAR Dataset/HARdata.txt");

#########################################################################################
# step 5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
#########################################################################################


library("data.table", lib.loc="~/R/win-library/3.1");
library("reshape2", lib.loc="~/R/win-library/3.1");
tidy<-aggregate(HARdata, by=list(HARdata$activity,HARdata$subject), FUN=mean,na.rm=TRUE) ;

tidy<-tidy[,-c(2,3,567)];
 library("plyr", lib.loc="~/R/win-library/3.1")
tidy<-rename(tidy,c("Group.1"="activity"));
write.table(tidy,file="./data/UCI HAR Dataset/tidy.txt");
