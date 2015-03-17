getColNames <- function() {
        featureNames <- read.table("UCI HAR Dataset/features.txt", sep = "", header = FALSE)
        featureNames[, 2] <- gsub("-", "_", featureNames[, 2])
        featureNames[, 2] <- gsub("\\(\\)", "", featureNames[, 2])
        featureNames[, 2] <- gsub(",", "_", featureNames[, 2])
        featureNames[, 2] <- gsub("\\)_", "_", featureNames[, 2])
        featureNames[, 2] <- gsub("\\(", "_", featureNames[, 2])
        featureNames[, 2] <- gsub("\\)", "", featureNames[, 2])
        featureNames[, 2]       
}

getTrainData <- function() {
        partData <- read.table("UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE)
        colnames(partData) <- c("id")
        trainData <- read.table("UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE) 
        colnames(trainData) <- getColNames()
        activityData <- read.table("UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE)
        colnames(activityData) <- c("Activity_Id")        
        activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE)
        activityData[, "Activity_Label"] <- activityLabels[activityData$Activity_Id, ]$V2
        allData <- cbind(partData, activityData, trainData)
        allData
}

getTestData <- function() {
        partData <- read.table("UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE)
        colnames(partData) <- c("id")
        testData <- read.table("UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)
        colnames(testData) <- getColNames()
        activityData <- read.table("UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE)
        colnames(activityData) <- c("Activity_Id")
        activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE)
        activityData[, "Activity_Label"] <- activityLabels[activityData$Activity_Id, ]$V2
        allData <- cbind(partData, activityData, testData)
        allData
}

mergeTestTrainData <- function(testData, trainData) {
        rbind(testData, trainData)
}

keepMeanStd <- function(mergedData) {
        tidyData <- data.frame(mergedData[, "id"])
        newColNames <- c("id")
        for(col in colnames(mergedData)) {
                if(col != "id") {
                        if(col == "Activity_Id" | col == "Activity_Label") {
                                tidyData <- cbind(tidyData, mergedData[, col])
                                newColNames <- c(newColNames, col)        
                        } else if((grepl("mean", col) | grepl("std", col)) &
                                          !grepl("angel", col)) {
                                tidyData <- cbind(tidyData, mergedData[, col]) 
                                newColNames <- c(newColNames, col)
                        }  
                        
                }
        }
        colnames(tidyData) <- newColNames
        tidyData
}

getPlyedData <- function(df, by, i) {
        ddply(df, by,  function(d) {
                c(mean(d[[i]], na.rm=TRUE))
        })    
}

createAvgData <- function(keepMeanStd) {
        require(plyr)
        newData <- getPlyedData(keepMeanStd, c("id", "Activity_Id", "Activity_Label"), 4)
        colNames <- colnames(keepMeanStd)
        for(i in 5:length(colNames)) {
                summaryData <- getPlyedData(keepMeanStd, c("id", "Activity_Id", "Activity_Label"), i)           
                newData <- cbind(newData, summaryData[, 4])
        }
        
        colnames(newData) <- colNames
        newData
}

saveFile <- function(df, fileName) {
        write.table(df, fileName, sep=" ", row.names=FALSE)
}
