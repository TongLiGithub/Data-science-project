fileURL<-'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(fileURL, 'assigndata.zip')
unzip('assigndata.zip')

##read in test data
###each element in a feature vector corresponds to the header of 
###one column in X_test
testdata_sub<-read.csv('test/subject_test.txt',sep='',header=F)
testdata_x<-read.csv('test/X_test.txt', sep='', header=F)
testdata_y<-read.csv('test/y_test.txt', sep='', header=F)
data_featurevec<-read.csv('features.txt', sep='', header=F)
colnames(testdata_sub)<-'subject'
colnames(testdata_y)<-'activity'
colnames(testdata_x)<-data_featurevec[[2]] #name columns in X_test
#with features

##merge all test data into 1 file
testdata_all<-cbind(testdata_sub, testdata_y, testdata_x) 


##read in training data (similar to test data)
###each element in a feature vector corresponds to the header of 
###one column in X_test
traindata_sub<-read.csv('train/subject_train.txt',sep='',header=F)
traindata_x<-read.csv('train/X_train.txt', sep='', header=F)
traindata_y<-read.csv('train/y_train.txt', sep='', header=F)
data_featurevec<-read.csv('features.txt', sep='', header=F)
colnames(traindata_sub)<-'subject'
colnames(traindata_y)<-'activity'
colnames(traindata_x)<-data_featurevec[[2]] #name columns in X_test
#with features

##merge all training data into 1 file
traindata_all<-cbind(traindata_sub, traindata_y, traindata_x) 
                     

##merge training and test data
alldata<-rbind(testdata_all, traindata_all)

###Uses descriptive activity names to name the activities in the data set
alldata$activity[alldata$activity == "1"] <- "WALKING"
alldata$activity[alldata$activity == "2"] <- "WALKING_UPSTAIRS"
alldata$activity[alldata$activity == "3"] <- "WALKING_DOWNSTAIRS"
alldata$activity[alldata$activity == "4"] <- "SITTING"
alldata$activity[alldata$activity == "5"] <- "STANDING"
alldata$activity[alldata$activity == "6"] <- "LAYING"

##Extracts only the measurements on the mean and standard deviation 
##for each measurement.
###get index of columns which contain "mean()" and "std()"
mean<-grepl("^.+mean()", data_featurevec[[2]])
sum(mean)
feature_mean<-which(mean)
sd<-grepl("^.+std()", data_featurevec[[2]])
sum(sd)
feature_sd<-which(sd)

###alldata without subject, activity and datatype columns
alldata_part<-alldata[, 3:563]
new<-alldata_part[, c(feature_mean, feature_sd)]
extracted<-cbind(alldata[, c(1,2)], new)
write.table(file='extracted_mean_std.txt', extracted)


##create an independent tidy data set with the average of each
##variable for each activity and each subject.
walk<-subset(extracted, activity=="WALKING")
up<-subset(extracted, activity=="WALKING_UPSTAIRS")
down<-subset(extracted, activity=="WALKING_DOWNSTAIRS")
stand<-subset(extracted, activity=="STANDING")
sit<-subset(extracted, activity=="SITTING")                    
lay<-subset(extracted, activity=="LAYING")

##get mean for each column for each subject
for (i in 1:30) {
    w<-subset(walk, subject==i)
    part<-w[, 3:81]
    m[[i]]<-colMeans(part)
}
head(m)
M<-as.data.frame(m)
colnames(M)<-1:30
##transpose M
walking<-t(M)


for (i in 1:30) {
    u<-subset(up, subject==i)
    part<-u[, 3:81]
    m[[i]]<-colMeans(part)
}
head(m)
M<-as.data.frame(m)
colnames(M)<-1:30
##transpose M
walkingup<-t(M)

for (i in 1:30) {
    d<-subset(down, subject==i)
    part<-d[, 3:81]
    m[[i]]<-colMeans(part)
}
M<-as.data.frame(m)
colnames(M)<-1:30
##transpose M
walkingdown<-t(M)

for (i in 1:30) {
    st<-subset(stand, subject==i)
    part<-st[, 3:81]
    m[[i]]<-colMeans(part)
}
M<-as.data.frame(m)
colnames(M)<-1:30
##transpose M
standing<-t(M)

for (i in 1:30) {
    si<-subset(sit, subject==i)
    part<-si[, 3:81]
    m[[i]]<-colMeans(part)
}
M<-as.data.frame(m)
colnames(M)<-1:30
##transpose M
sitting<-t(M)

for (i in 1:30) {
    la<-subset(lay, subject==i)
    part<-la[, 3:81]
    m[[i]]<-colMeans(part)
}
M<-as.data.frame.table(m)
##transpose M
laying<-t(M)

##combine and convert
new_data<-rbind(walking, walkingup, walkingdown, standing, sitting, laying)
new<-as.data.frame(new_data)

subject<-rep(1:30, 6)
activity<-rep(c('WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS', 'STANDING', 'SITTING', 'LAYING'), each=30)

###combine subject, activity, and new
final_data<-cbind(subject, activity, new)


write.table(file='dataset.txt', final_data, row.names=FALSE)

