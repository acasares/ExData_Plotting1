# plot2.R                        29 de Abril de 2016
# Exploratory Data Analysis: Course Project 1
# This assignment uses data from the UC Irvine Machine Learning Repository,
# We will use the "Individual household electric power consumption Data Set":

if(!file.exists("./data")){dir.create("./data")}
if (!file.exists("./data/household_power_consumption.txt")) {
    print('household_power_consumption not found in ./data')
    fileUrl1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl1, destfile='./data/UCI_HAR_Dataset.zip')
    zipfile <- 'UCI_HAR_Dataset.zip'
    print("Downloaded. Please unzip it manually in ./data")
} else {
    print('Found the unzipped file household_power_consumption: Reads it.')
    library(dplyr)
    library(lubridate)
    # Compute the lines to be read:
    first_line <- read.table('./data/household_power_consumption.txt', header = TRUE, sep = ";",
                             nrows = 1, stringsAsFactors = FALSE) 
    date0 <- dmy(first_line$Date); init_hour <- first_line$Time
    disp <- as.numeric(substring(init_hour, first=1,last=2))*60 + 
        as.numeric(substring(init_hour, first=4,last=5)) # Minutes of starting day
    init <- ymd("2007-02-01") # First day we are interested in
    #day1 <- wday(init, label = TRUE)
    #day2 <- wday(ymd("2007-02-02"), label = TRUE)
    # Computes the number of minutes we should skip = lines to skip:
    lapso <- as.integer(as.duration(interval(date0,init))/60) - disp + 1 # Counts the heading
    
    # Only read 2880 lines (minutes in 2 days), after skipping the previous lines
    household <- read.table('./data/household_power_consumption.txt', header = FALSE, sep = ";",
                            na.strings = "?", skip = lapso, nrows = 2880, stringsAsFactors = FALSE)
    names(household) <- names(first_line)
    # Makes the plot 2:
    # day_week = substring(wday(dmy(Date),label=TRUE),first=1,last=3)
    household <- mutate(household, t = id(household)) # t: elapsed minutes
    
    png(file="./data/plot2.png")
    with(household, plot(t, Global_active_power, type = 'l',
                         xlab = " ", xaxt = 'n',
                         ylab = "Global Active Power (kilowatts)"))
    axis(1,labels=c("Thu","Fri","Sat"),at = c(10,1440,2870))
    dev.off()
    print("Please see drawn plot ./data/plot2.png")
}    