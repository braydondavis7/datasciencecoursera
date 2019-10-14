## Getting and cleaning data project
library(dplyr)

#Read data into R
features <- read.table("/Users/braydondavis/Downloads/UCI HAR Dataset/features.txt")
colnames(features) <- c("n","functions")

activities <- read.table("/Users/braydondavis/Downloads/UCI HAR Dataset/activity_labels.txt")
colnames(activities) <- c("code","activity")

subject_test <- read.table("/Users/braydondavis/Downloads/UCI HAR Dataset/test/subject_test.txt")
colnames(subject_test) <- "subject"

x_test <- read.table("/Users/braydondavis/Downloads/UCI HAR Dataset/test/X_test.txt")
colnames(x_test) <- features$functions

y_test <- read.table("/Users/braydondavis/Downloads/UCI HAR Dataset/test/y_test.txt")
colnames(y_test) <- "code"

subject_train <- read.table("/Users/braydondavis/Downloads/UCI HAR Dataset/train/subject_train.txt")
colnames(subject_train) <- "subject"

x_train <- read.table("/Users/braydondavis/Downloads/UCI HAR Dataset/train/X_train.txt")
colnames(x_train) <- features$functions

y_train <- read.table("/Users/braydondavis/Downloads/UCI HAR Dataset/train/y_train.txt")
colnames(y_train) <- "code"

#Rbind x_test x_train
X <- rbind(x_test,x_train)

#Rbind y_test and y_train
Y <- rbind(y_test,y_train)

#Rbind the subject datasets
Subject <- rbind(subject_train, subject_test)

#Merge data with subject, y and x
Merged_Data <- cbind(Subject,Y,X)

#Extract mean and standard deviation of each measurement
clean_data <- Merged_Data[,c(grep("subject|code|mean|std",names(Merged_Data))),drop=F]

#Label the activities instead of the code
clean_data$code <- activities[clean_data$code,2]

# Label the data set with descriptive variable names
colnames(clean_data)[2] <- "activity"
names(clean_data) <- gsub("Acc","Accelerometer",names(clean_data))
names(clean_data) <- gsub("Gyro","Gyroscope",names(clean_data))
names(clean_data)<-gsub("BodyBody", "Body", names(clean_data))
names(clean_data)<-gsub("Mag", "Magnitude", names(clean_data))
names(clean_data)<-gsub("^t", "Time", names(clean_data))
names(clean_data)<-gsub("^f", "Frequency", names(clean_data))
names(clean_data)<-gsub("tBody", "TimeBody", names(clean_data))
names(clean_data)<-gsub("-mean()", "Mean", names(clean_data), ignore.case = TRUE)
names(clean_data)<-gsub("-std()", "STD", names(clean_data), ignore.case = TRUE)
names(clean_data)<-gsub("-freq()", "Frequency", names(clean_data), ignore.case = TRUE)
names(clean_data)<-gsub("angle", "Angle", names(clean_data))
names(clean_data)<-gsub("gravity", "Gravity", names(clean_data))

#average of each variable by subject and activity (using dplyr)
average_over_subject_activity <- clean_data %>% group_by(subject,activity) %>% summarise_all(funs(mean))


