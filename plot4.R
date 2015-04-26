# Using the base plotting system, this R code file creates a PNG file with a plot showing the total PM2.5 emission from coal combustion-related sources for each of the years 1999, 2002, 2005, and 2008.
# The generated plot serves answering the following question: Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?


library(dplyr) # Package required for data manipulation.

source("downloadData.R") # Loading a custom function to load the source data.

# Declaring constants with file/directory paths:
dataDirectory = "./data"
emissionsDataFilePath = file.path(dataDirectory, "summarySCC_PM25.rds")
sccTableFilePath = file.path(dataDirectory, "Source_Classification_Code.rds")
destFilePath = "./Plot4.png"

# Ensure that source data files are available:
downloadData(dataDirectory)

# Read in data from source data files:
emissionData <- readRDS(emissionsDataFilePath) # This line will likely take a few seconds. Be patient!
sccTable <- readRDS(sccTableFilePath)


# Filter SCC for sources related to coal-combustion:
relevantSCC <- filter(sccTable, EI.Sector == "Fuel Comb - Comm/Institutional - Coal" | 
                         EI.Sector == "Fuel Comb - Electric Generation - Coal" | 
                         EI.Sector == "Fuel Comb - Industrial Boilers, ICEs - Coal") 

# Prepare data for plotting...
plotData <- filter(emissionData, SCC %in% relevantSCC$SCC) %>%
      group_by(year) %>%
      summarize(totalEmission = sum(Emissions)) %>%
      mutate(totalEmission = totalEmission / 1e3)

# Create plot file...
png(filename = destFilePath, width = 480, height = 480, units = "px") #Set graphics device to PNG.
barplot(plotData$totalEmission, names = plotData$year, main ="Total emissions of PM2.5 from sources related to\ncoal combustion in the United States", xlab = "Year", ylab = "PM2.5 emissions (in thousand tons)", ylim = c(0, 600))
dev.off() #Leave PNG graphics device again.