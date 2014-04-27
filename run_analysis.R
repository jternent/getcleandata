cleanse <- function() {
  features <- read.table('features.txt',stringsAsFactors=FALSE)
  features <- features$V2
  features <- c(features,'activity','subject')
  activities <- read.table('activity_labels.txt')
  colnames(activities)<-c('activity_num','activity_label')
  fulldata <- rbind(merge_dat('train',features,activities),merge_dat('test',features,activities))
  sumdata<-aggregate(fulldata[!names(fulldata) %in% c('subject','activity_label','activity')], by=fulldata[c('subject','activity_label')], FUN=mean)
  sumdata
}

merge_dat <- function (dir, features, activities, filter="(\\-mean\\(\\)|\\-std\\(\\))") {
  
  # read 3 files and join them using "train" or "test":
  # ./train/X_train.txt, ./train/y_train.txt, ./train/subject_train.txt or
  # ./test/X_test.txt, ./test/y_test.txt, ./test/subject_test.txt
  # return a single data frame with labeled columns
  # containing only columns whose names match the filter regex

  data <- read.table(file.path(dir,paste("X_",dir,".txt",sep='')),stringsAsFactors=FALSE)
  labels <- read.table(file.path(dir,paste("y_",dir,".txt",sep='')),stringsAsFactors=FALSE)
  subjects <- read.table(file.path(dir,paste("subject_",dir,".txt",sep='')),stringsAsFactors=FALSE)
  data <- cbind(data,labels,subjects)
  colnames(data)<-features
  data <- subset(data,select=c(grep(filter,features,value=TRUE),'activity','subject'))
  merge(data,activities,by.x='activity',by.y='activity_num',sort=FALSE,all.x=TRUE)
}
