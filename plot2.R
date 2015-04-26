# Using the base plotting system, this R code file creates a PNG file with a plot showing the total PM2.5 emission from all sources in the Baltimore City, Maryland (fips == "24510") for each of the years 1999, 2002, 2005, and 2008.
# The generated plot serves answering the following question: Have total emissions from PM2.5 decreased in the in Baltimore City, Maryland from 1999 to 2008?

library(dplyr) # Package required for data manipulation.

source("downloadData.R") # Loading a custom function to load the source data.

# Declaring constants with file/directory paths:
dataDirectory = "./data"
emissionsDataFilePath = file.path(dataDirectory, "summarySCC_PM25.rds")
destFilePath = "./Plot2.png"

# Ensure that source data files are available:
downloadData(dataDirectory)

# Read in data from source data file:
emissionData <- readRDS(emissionsDataFilePath) # This line will likely take a few seconds. Be patient!

# Prepare data for plotting...
plotData <- filter(emissionData, fips == "24510") %>%
      group_by(year) %>%
      summarize(totalEmission = sum(Emissions)) %>%
      mutate(totalEmission = totalEmission / 1e3)

# Create plot file...
png(filename = destFilePath, width = 480, height = 480, units = "px") #Set graphics device to PNG.
barMidPoints <- barplot(plotData$totalEmission, names = plotData$year, main ="Total emissions of PM2.5 in Baltimore City, Maryland", xlab = "Year", ylab = "PM2.5 emissions (in thousand tons)", ylim = c(0, 3.5))
lmFit <- lm(plotData$totalEmission ~ barMidPoints[, 1]) # Create regression line params.
abline(lmFit, col = "Red", lwd = 2) # Add regression line.
dev.off() #Leave PNG graphics device again.