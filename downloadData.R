downloadData <- function(dataDirectory) { 
      sourceDataURL = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
      dataDirectory = "./data"
      sourceDataZipFilePath = file.path(dataDirectory, "exdata_data_NEI_data.zip")
      
      if (!file.exists(sourceDataZipFilePath)) {
            if (!file.exists(dataDirectory)) {
                  dir.create(dataDirectory)
            }
            download.file(sourceDataURL, sourceDataZipFilePath, method = "auto")      
      }
      
      unzip(sourceDataZipFilePath, exdir = dataDirectory)
}