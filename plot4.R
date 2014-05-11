if (!file.exists("data")){
  dir.create("data")
}

temp <- tempfile()
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

download.file(fileURL, temp)
dateDownloaded <- date()

houseData <- read.table(unz(temp, "household_power_consumption.txt"),sep=";",
                        header=FALSE, na.strings="?", skip=66637, nrows=2881,
                        col.names=c("Date","Time","Global_active_power",
                                    "Global_reactive_power","Voltage","Global_intensity",
                                    "Sub_Metering_1","Sub_Metering_2","Sub_Metering_3"))
unlink(temp)

houseData$Time <- strptime(paste(houseData$Date,houseData$Time),format="%d/%m/%Y %H:%M:%S",tz="")
houseData$Date <- as.Date(houseData$Date,format="%d/%m/%Y")

png(filename="plot4.png",width=480,height=480,units="px")

with(houseData, {
  par(mfrow = c(2,2))
  plot(houseData$Time,houseData$Global_active_power,type="l",ylab="Global Active Power",
       xlab="")
  plot(houseData$Time,houseData$Voltage,type="l",ylab="Voltage",
       xlab="datetime")
  with(houseData, {
    plot(houseData$Time,houseData$Sub_Metering_1,type="n",ylab="Energy sub metering",
         xlab="")
    lines(houseData$Time,houseData$Sub_Metering_1,type="l")
    lines(houseData$Time,houseData$Sub_Metering_2,type="l",col="red")
    lines(houseData$Time,houseData$Sub_Metering_3,type="l",col="blue")
    legend("topright", legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
           col=c("black","red","blue"),lwd=2,bty="n")    
  })
  plot(houseData$Time,houseData$Global_reactive_power,type="l",ylab="Global_reactive_power",
       xlab="datetime")
})
dev.off()