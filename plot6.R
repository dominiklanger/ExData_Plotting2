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

# Prepare data...
plotData <- filter(emissionData, fips == "24510" | fips == "06037", SCC %in% relevantSCC$SCC) %>%
      group_by(fips, year) %>%
      summarize(totalEmission = sum(Emissions)) %>%
      mutate(totalEmission = totalEmission / 1e3)

plotData$fips[plotData$fips == "24510"] <- "Baltimore City, MD"
plotData$fips[plotData$fips == "06037"] <- "Los Angeles County, CA"

# Plot data...
ggplot(plotData, aes(x = year, y = totalEmission)) +
      facet_grid(. ~ fips) +
      geom_bar(stat="identity", fill = "Grey") +
      stat_smooth(method="lm", se=FALSE, colour = "Red") +
      xlab("Year") +
      ylab("PM2.5 emissions (in thousand tons)") +
      ggtitle("Total emissions of PM2.5 from motor vehicles") +
      theme(plot.title = element_text(face="bold", vjust=1)) +
      scale_x_continuous(limits = c(1997.5, 2009.5), breaks = c(1999, 2002, 2005, 2008))

# Save plot to file..
ggsave(destFilePath, width=9, height=6.6)