# Using the base plotting system, this R code file creates a PNG file with a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.
# The generated plot serves answering the following question: Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?

library(dplyr) # Package required for data manipulation.

source("downloadData.R") # Loading a custom function to load the source data.

# Declaring constants with file/directory paths:
dataDirectory = "./data"
emissionsDataFilePath = file.path(dataDirectory, "summarySCC_PM25.rds")
destFilePath = "./Plot1.png"

# Ensure that source data files are available:
downloadData(dataDirectory)

# Read in data from source data file:
emissionData <- readRDS(emissionsDataFilePath) # This line will likely take a few seconds. Be patient!

# Prepare data for plotting...
plotData <- group_by(emissionData, year) %>%
      summarize(totalEmission = sum(Emissions)) %>%
      mutate(totalEmission = totalEmission / 1e6)

# Create plot file...
png(filename = destFilePath, width = 480, height = 480, units = "px") #Set graphics device to PNG.
barMidPoints <- barplot(plotData$totalEmission, names.arg = plotData$year, axis.lty = 1, main ="Total emissions of PM2.5 in the United States", xlab = "Year", ylab = "PM2.5 emissions (in Mio. tons)", ylim = c(0, 8))
lmFit <- lm(plotData$totalEmission ~ barMidPoints[, 1])
abline(lmFit, col = "Red", lwd = 2)
dev.off() #Leave PNG graphics device again.