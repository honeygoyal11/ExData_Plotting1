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
par(mfrow=c(2,2))
with(dt,plot(Datetime,Global_active_power, ylab = "Global Active Power",xlab="",type="l"))

with(dt,plot(Datetime,Voltage, ylab = "Voltage",type="l"))

with(dt,plot(Datetime,Sub_metering_1,type="l", ylab="Energy Submetering", xlab=""))
with(dt,points(Datetime,Sub_metering_2,type="l",col="red"))
with(dt,points(Datetime,Sub_metering_3,type="l",col="blue"))
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, lwd=2.5, col=c("black", "red", "blue")
)
with(dt,plot(Datetime,Global_reactive_power,type="l"))

#close device
dev.off()
