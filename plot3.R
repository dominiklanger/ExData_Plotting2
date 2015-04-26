# Using the ggplot2 graphics system, this R code file creates a PNG file with plots serving to answer the following questions: 
# - Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City?
# - Which have seen increases in emissions from 1999–2008? 

library(dplyr) # Package required for data manipulation.
library(ggplot2) # Package required for ggplot2 graphics system

source("downloadData.R") # Loading a custom function to load the source data.

# Declaring constants with file/directory paths:
dataDirectory = "./data"
emissionsDataFilePath = file.path(dataDirectory, "summarySCC_PM25.rds")
destFilePath = "./Plot3.png"

# Ensure that source data files are available:
downloadData(dataDirectory)

# Read in data from source data file:
emissionData <- readRDS(emissionsDataFilePath) # This line will likely take a few seconds. Be patient!

# Prepare data and plot it...
filter(emissionData, fips == "24510") %>%
      group_by(type, year) %>%
      summarize(totalEmission = sum(Emissions)) %>%
      ggplot(aes(x = year, y = totalEmission, group = type, shape = type)) +
            geom_line() +
            geom_point(size=3, fill="white") +
            xlab("Year") +
            ylab("PM2.5 emissions (in tons)") +
            ggtitle("Total emissions of PM2.5 by source in the Baltimore City, Maryland") +
            theme(plot.title = element_text(lineheight=.8, face="bold")) +
            scale_shape_discrete(breaks=c("POINT","NONPOINT","ON-ROAD", "NON-ROAD")) +
            theme(legend.title=element_blank())

# Save plot to file..
ggsave(destFilePath, width=9, height=6.6)