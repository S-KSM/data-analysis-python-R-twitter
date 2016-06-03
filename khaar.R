#install.packages("dplyr")
#install.packages("ggplot2")
#install.packages("GGally")
library(dplyr) #load the dplyr package used for data manipulation
library(ggplot2) #package for plotting
library(GGally)  #additional package on top of ggplot2 that adds features such as the ggpairs function
tweets <- read.csv("./cleandata/tweets.csv",sep = ",") # read the tweets
tweets <- tweets[,c(2,3)] # select the useful columns that are the number of tweets and their date
AQ2009 <- read.csv("./cleandata/PM2.csv",sep = ",") #read the airquality data
tweets <- tbl_df(tweets) # tbl_df fuction is a dplyr function that makes a dataframe, it is easier to show a data frame
names(tweets) <- c("Date", "Number.of.Tweets") # changing the name of the tweets data frame's columns
AQ2009 <- tbl_df(AQ2009) # tbl_df fuction is a dplyr function that makes a dataframe, it is easier to show a data frame

### this nextline uses the concept of pipeline.
### A %>% B means the result of A is delivered to the function B
### First, we choose columns Date and PM2.5 from the AQ2009, then we group the results by Date, then we take the average of all the states PM2.5 for everyday
AQ_final <- AQ2009[,c(2,3)] %>% group_by(Date) %>% summarise("Average.PM2.5"=mean(Daily.Mean.PM2.5.Concentration))
### We put the dates in the right format
AQ_final$Date <- as.Date(AQ_final$Date , "%m/%d/%Y")
### We put the dates in the right format
tweets$Date <- as.Date(tweets$Date , "%Y-%m-%d")
### Combine (merge) the two data frames by Date to create a new data frame that consists of the Date, number of tweets, and the PM2.5.
final_df <- merge(x= AQ_final,y = tweets,by.x = "Date",by.y = "Date")
### open a graphing device that will save the result of the next plot in a file called corr.png
png(filename = "corr.png")
### ggpairs creates several plots about the distribution of each parameter as well as its correlation with other columns of the data frame
ggpairs(final_df)
### closes the graphing device and saves the plot's image in corr.png
dev.off()