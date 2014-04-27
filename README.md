getcleandata
============

Programming Assignment for Coursera Getting and Cleaning Data


Loading Data
=======

This exercise presupposes that the file is in the original hierarchy, with features.txt in the top-level directory and train/ and test/ subfolders with the files for X observations, labels, and subjects in the sub-directories. To execute the script, just invoke the cleanse() function after 
sourcing the script run_analysis.R.

Data Consolidation - Step 1
------
Load the feature descriptions from features.txt and append "activity" and "subject" labels
```
features <- read.table("features.txt",stringsAsFactors=FALSE)
features <- features$V2
features <- c(features,'activity','subject')
```

Data Consolidation - Step 2
------
Merge the three files in the test and train directories (data,subject,activity) using
merge_dat function. merge_dat takes three parameters, a directory name (train or test), 
a vector of feature labels from step 1, and a regex to select columns from the combined data set
(defaults to functions containing -mean() and -std())

Data Consolidation - Step 3
------
Use subset() to select only the columns of interest using the regexp passed in the filter parameter.
```
data <- merge_dat(directory, features, filter=regexp)
```


Data Consolidation - Step 4
------
Use rbind to merge the training and test data sets
```
fulldata <- rbind(merge_dat('train',features),merge_data('test',features))
```

Data Aggregation - Step 5
------
Use aggregate() to get the mean of all columns by subject and activity_label.
```
sumdata<-aggregate(fulldata[!names(fulldata) %in% c('subject','activity_label','activity')], by=fulldata[c('subject','activity_label')], FUN=mean)
```
