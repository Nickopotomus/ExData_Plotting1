if (!file.exists("data")){
  dir.create("data")
}

temp <- tempfile()
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

download.file(fileURL, temp)
dateDownloaded <- date()

houseData <- read.table(unz(temp, "household_power_consumption.txt"),sep=";",
                        header=FALSE, na.strings="?", skip=66637, nrows=2880,
                        col.names=c("Date","Time","Global_active_power",
                                    "Global_reactive_power","Voltage","Global_intensity",
                                    "Sub_metering_1","Sub_Metering_2","Sub_Metering_3"))
unlink(temp)

houseData$Time <- strptime(paste(houseData$Date,houseData$Time),format="%d/%m/%Y %H:%M:%S",tz="")
houseData$Date <- as.Date(houseData$Date,format="%d/%m/%Y")

png(filename="plot1.png",width=480,height=480,units="px")
with(houseData, hist(houseData$Global_active_power,main="Global Active Power",
                     xlab="Global Active Power (kilowatts)",col= "red"))
dev.off()
