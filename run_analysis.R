## Load the packages and get the data
packages <- c("data.table", "reshape2")
sapply(packages, require, character.only=T, quietly=T)
path <- getwd()
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, file.path(path, "dataFiles.zip"))
unzip(zipfile = "dataFiles.zip")

##Load activity labels+features
activity_labels <- fread(file.path(path, "UCI HAR Dataset/activity_labels.txt"), 
                         col.names = c("class_labels", "activity_name"))
features <- fread(file.path(path, "UCI HAR Dataset/features.txt"), col.names = c("index", "feature_Names"))
features_wanted <- grep("(mean|std)\\(\\)", features[ ,feature_Names])
measurements <- features[features_wanted, feature_Names]
measurements <- gsub("[()]", "", measurements)

##load train datasets
train <- fread(file.path(path, "UCI HAR Dataset/train/X_train.txt"))[ ,features_wanted, with= F]
data.table::setnames(train, colnames(train), measurements)
training_activities <- fread(file.path(path, "UCI HAR Dataset/train/y_train.txt"), col.names= c("Activity"))
trainsubjects <- fread(file.path(path, "UCI HAR Dataset/train/subject_train.txt"), col.names= c("SubjectNumber")) 
train <- cbind(train, training_activities, trainsubjects)

##load test datasets
test <- fread(file.path(path, "UCI HAR Dataset/test/X_test.txt"))[ , features_wanted, with=F]
data.table::setnames(test, colnames(test), measurements)
test_activities <- fread(file.path(path, "UCI HAR Dataset/test/y_test.txt"), col.names = c("Activity"))
test_subjects <- fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt"), col.names = c("SubjectNumber"))
test <- cbind(test, test_activities, test_subjects)

##merged data sets 
mergeddata <- rbind(train, test)

##convert class labels to explicit activity names
mergeddata[["Activity"]] <- factor(mergeddata[ ,Activity], levels = activity_labels[["class_labels"]], 
                                   labels = activity_labels[["activity_name"]])
mergeddata[["SubjectNumber"]] <- as.factor(mergeddata[ ,SubjectNumber])
mergeddata <- reshape2::melt(data = mergeddata, id = c("SubjectNumber", "Activity"))
mergeddata <- reshape2::dcast(data = mergeddata, formula = SubjectNumber + Activity ~ variable, fun.aggregate = sum)
data.table::fwrite(mergeddata, file = "tidyData.txt", quote = F)
