# plot4.R                        29 de Abril de 2016
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
    
    # Computes the number of minutes we should skip = lines to skip:
    lapso <- as.integer(as.duration(interval(date0,init))/60) - disp + 1 # Counts the heading
    
    # Only read 2880 lines (minutes in 2 days), after skipping the previous lines
    household <- read.table('./data/household_power_consumption.txt', header = FALSE, sep = ";",
                            na.strings = "?", skip = lapso, nrows = 2880, stringsAsFactors = FALSE)
    names(household) <- names(first_line)
    
    household <- mutate(household, t = id(household)) # t: elapsed minutes
    
    # Makes plot 4:
    png(file="./data/plot4.png")
    par(mfcol = c(2, 2), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))
    with(household, {
        # Plot [1,1]
        plot(t, Global_active_power, type = 'l',
                             xlab = " ", xaxt = 'n',
                             ylab = "Global Active Power")
        axis(1,labels=c("Thu","Fri","Sat"),at = c(10,1440,2870))
        # Plot [2,1]
        plot(t, Sub_metering_1, type = 'l', col = "gray36",lwd = 2,
                         xlab = " ", xaxt = 'n',
                         ylab = "Energy sub metering")
        points(t, Sub_metering_2, type = 'l', col = "red",lwd = 2)
        points(t, Sub_metering_3, type = 'l', col = "blue",lwd = 2)
        legend("topright", lwd = 1, cex = 0.7, col = c("gray36", "red", "blue"), legend = c("Sub_metering_1",
                                        "Sub_metering_2", "Sub_metering_3"), bty='n')
        axis(1,labels=c("Thu","Fri","Sat"),at = c(10,1440,2870))
        # Plot [1,2] Datetime vs. Voltage
        plot(t, Voltage, type = 'l',
             xlab = "Datetime", xaxt = 'n',
             ylab = "Voltage")
        axis(1,labels=c("Thu","Fri","Sat"),at = c(10,1440,2870))
        
        # Plot [2,2] Datetime vs. Global reactive power
        plot(t, Global_reactive_power, type = 'l',
             xlab = "Datetime", xaxt = 'n',
             ylab = "Global reactive power")
        axis(1,labels=c("Thu","Fri","Sat"),at = c(10,1440,2870))
        })

    dev.off()
    print("Please see drawn plot ./data/plot4.png")
} 