# Using the base plotting system, this R code file creates a PNG file with a plot showing PM2.5 emissions from motor vehicle sources in Baltimore City, Maryland, for each of the years 1999, 2002, 2005, and 2008.
# The generated plot serves answering the following question: How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City? 


library(dplyr) # Package required for data manipulation.

source("downloadData.R") # Loading a custom function to load the source data.

# Declaring constants with file/directory paths:
dataDirectory = "./data"
emissionsDataFilePath = file.path(dataDirectory, "summarySCC_PM25.rds")
sccTableFilePath = file.path(dataDirectory, "Source_Classification_Code.rds")
destFilePath = "./Plot5.png"

# Ensure that source data files are available:
downloadData(dataDirectory)

# Read in data from source data files:
emissionData <- readRDS(emissionsDataFilePath) # This line will likely take a few seconds. Be patient!
sccTable <- readRDS(sccTableFilePath)


# Filter SCC for sources related to motor vehicles:
relevantSCC <- filter(sccTable, 
                      EI.Sector == "Mobile - Aircraft" | 
                      EI.Sector == "Mobile - Commercial Marine Vessels" | 
                      EI.Sector == "Mobile - Locomotives" | 
                      EI.Sector == "Mobile - Non-Road Equipment - Diesel" | 
                      EI.Sector == "Mobile - Non-Road Equipment - Gasoline" | 
                      EI.Sector == "Mobile - Non-Road Equipment - Other" | 
                      EI.Sector == "Mobile - On-Road Diesel Heavy Duty Vehicles" | 
                      EI.Sector == "Mobile - On-Road Diesel Light Duty Vehicles" | 
                      EI.Sector == "Mobile - On-Road Gasoline Heavy Duty Vehicles" |
                      EI.Sector == "Mobile - On-Road Gasoline Light Duty Vehicles" 
) 

# Prepare data for plotting...
plotData <- filter(emissionData, fips == "24510", SCC %in% relevantSCC$SCC) %>%
      group_by(year) %>%
      summarize(totalEmission = sum(Emissions))

# Create plot file...
png(filename = destFilePath, width = 480, height = 480, units = "px") #Set graphics device to PNG.
barMidPoints <- barplot(plotData$totalEmission, names = plotData$year, axis.lty = 1, main ="Total emissions of PM2.5 from sources related to\nmotor vehicles in Baltimore City, Maryland", xlab = "Year", ylab = "PM2.5 emissions (in tons)", ylim = c(0, 900))
lmFit <- lm(plotData$totalEmission ~ barMidPoints[, 1]) # Create regression line params.
abline(lmFit, col = "Red", lwd = 2) # Add regression line.
dev.off() #Leave PNG graphics device again.