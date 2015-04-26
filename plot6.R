# Using the ggplot2 system, this R code file creates a PNG file with a plot that compare emissions from motor vehicle sources in Baltimore City, Maryland with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
# The generated plot serves answering the following question: Which city has seen greater changes over time in motor vehicle emissions?


library(dplyr) # Package required for data manipulation.
library(ggplot2) # Package required for ggplot2 graphics system

source("downloadData.R") # Loading a custom function to load the source data.

# Declaring constants with file/directory paths:
dataDirectory = "./data"
emissionsDataFilePath = file.path(dataDirectory, "summarySCC_PM25.rds")
destFilePath = "./Plot6.png"

# Ensure that source data files are available:
downloadData(dataDirectory)

# Read in data from source data files:
emissionData <- readRDS(emissionsDataFilePath) # This line will likely take a few seconds. Be patient!
sccTable <- readRDS(sccTableFilePath)

# Filter SCC for sources related to motor vehicles:
relevantSCC <- filter(sccTable, EI.Sector == "Mobile - On-Road Diesel Heavy Duty Vehicles" | 
                            EI.Sector == "Mobile - On-Road Diesel Light Duty Vehicles" | 
                            EI.Sector == "Mobile - On-Road Gasoline Heavy Duty Vehicles" |
                            EI.Sector == "Mobile - On-Road Gasoline Light Duty Vehicles" 
) 

# Prepare data and plot it...
filter(emissionData, fips == "24510" | fips == "06037", SCC %in% relevantSCC$SCC) %>%
      group_by(fips, year) %>%
      summarize(totalEmission = sum(Emissions)) %>%
      ggplot(aes(x = year, y = totalEmission, group = fips, shape = fips)) +
      geom_line() +
      geom_point(size=3, fill="white") +
      xlab("Year") +
      ylab("PM2.5 emissions (in tons)") +
      ggtitle("Total emissions of PM2.5 from motor vehicles") +
      theme(plot.title = element_text(lineheight=.8, face="bold")) +
      scale_shape_discrete(breaks=c("24510","06037"), labels=c("Baltimore City, MD", "Los Angeles County, CA")) +
      theme(legend.title=element_blank())

# Save plot to file..
ggsave(destFilePath, width=9, height=6.6)