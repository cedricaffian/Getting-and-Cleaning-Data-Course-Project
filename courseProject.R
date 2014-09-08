#reading features and activity data
features <- read.table("./Rcourse/UCI HAR Dataset/features.txt")
activities <- read.table("./Rcourse/UCI HAR Dataset/activity_labels.txt")

#reading train data
train <- read.table("./Rcourse/UCI HAR Dataset/train/X_train.txt") #561 features data
colnames(train) <- features$V2
y_train <- read.table("./Rcourse/UCI HAR Dataset/train/y_train.txt") #activity labels
train$activity <- y_train$V1
subject_train <- read.table("./Rcourse/UCI HAR Dataset/train/subject_train.txt") #subjects
train$subject <- factor(subject_train$V1)


#reading test data
test <- read.table("./Rcourse/UCI HAR Dataset/test/X_test.txt")
colnames(test) <- features$V2
y_test <- read.table("./Rcourse/UCI HAR Dataset/test/y_test.txt") #activity labels
test$activity <- y_test$V1
subject_test <- read.table("./Rcourse/UCI HAR Dataset/test/subject_test.txt") #subjects
test$subject <- factor(subject_test$V1)

#merge train and test sets
dataset <- rbind(test, train)

#filter column names
column.names <- colnames(dataset)
column.names.filtered <- grep("std\\(\\)|mean\\(\\)|activity|subject", column.names, value=TRUE)
dataset.filtered <- dataset[, column.names.filtered]
dataset.filtered$activitylabel <- factor(dataset.filtered$activity, labels= c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

#ids are activitylabel and subject
features.colnames = grep("std\\(\\)|mean\\(\\)", column.names, value=TRUE)
dataset.melt <-melt(dataset.filtered, id = c('activitylabel', 'subject'), measure.vars = features.colnames)
dataset.final <- dcast(dataset.melt, activitylabel + subject ~ variable, mean)
                                         
            