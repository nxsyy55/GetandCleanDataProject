setwd('F:/my document/CourseraMaterials/get&clean/project')
rm(list = ls())

# Merges the training and the test sets to create one data set.
trainX <- read.table("~/CourseraMaterials/get&clean/project/data/train/X_train.txt", quote="\"")
trainY <- read.table('~/CourseraMaterials/get&clean/project/data/train/y_train.txt',
                     header = F, col.names = 'Act')
trainSub <- read.table('data/train/subject_train.txt', hea = F, col.names = 'Subject')
train <- cbind(trainX, trainY, trainSub)

testX <- read.table("~/CourseraMaterials/get&clean/project/data/test/X_test.txt", quote="\"")
testY <- read.table('~/CourseraMaterials/get&clean/project/data/test/y_test.txt',
                    header = F, col.names = 'Act')
testSub <- read.table('data/test/subject_test.txt', hea = F, col.names = 'Subject')
test <- cbind(testX, testY, testSub)

data.all <- rbind(train, test) 

# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Appropriately labels the data set with descriptive variable names. 
features <- read.table('data/features.txt', string = F)
mean.id <- grep('mean', features$V2)
std.id <- grep('std', features$V2)
id <- c(mean.id, std.id, 562, 563)
data.trim <- data.all[,id]
names(data.trim)[1:79] <- features$V2[c(mean.id, std.id)]

# Uses descriptive activity names to name the activities in the data set
act.names <- c('WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS','SITTING', 'STANDING',
               'LAYING')
data.trim$Act <- as.factor(act.names[data.trim$Act])

# Creates a second, independent tidy data set with the average of each variable 
# for each activity and each subject. 
result <- data.frame()
for (i in 1:30){
  tem <- subset(data.trim, Subject == i)
  tem <- aggregate(tem[,c(1:79,81)],list(tem$Act), mean)
  result <- rbind(result, tem)
}
names(result)[1] <- 'Activity'
