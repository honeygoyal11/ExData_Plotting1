library(dplyr)

#variables
zipUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipFile <- "household_power_consumption.zip"
sourceFile <- "household_power_consumption.txt"
destFile <- "plot1.png"

# check if file is downloaded
if (!file.exists(zipFile)) {
    download.file(zipUrl,zipFile,mode="wb")
}

#check if source file exixts
if(!file.exists(sourceFile)){
    unzip("household_power_consumption.zip")
}

#read dataset with ; separator and "?" as NA 
dataset <- read.table(sourceFile,header = TRUE,nrows=2075259,sep=";",stringsAsFactors = FALSE,colClasses = c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"),na.strings = "?")

#combine date and time columns into new column Datetime
dataset <- dataset %>% mutate(Datetime = paste(Date, Time) )

#convert chr to date
dataset$Date <- as.Date(dataset$Date, "%d/%m/%Y")

#filter dataset
dt <- dataset %>% filter(Date=="2007-02-01" | Date=="2007-02-02")

#convert chr to datetime
dt$Datetime <-  strptime(dt$Datetime, "%d/%m/%Y %H:%M:%S") 

#check if file exixts
if(file.exists(destFile)){
    file.remove(destFile)
}
#open png device
png(destFile, width=480, height=480)

#plot graph
hist(dt$Global_active_power,col="red",xlab = "Global Active Power (kilowatts)",main = "Global Active Power")

#close device
dev.off()

