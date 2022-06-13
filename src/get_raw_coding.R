################################################################

# Downloads the raw coding -- DOIs and associated 
# classifications of web data (e.g., web scraping vs. APIs) -- 
# from Google Drive and stores it in the repository's 
# data folder.

# This file can only be run by the principle investigators,
# who have edit rights on the raw coding.

# The most recent version of the file is available
# in the \data\coding folder of this repository.

################################################################

# Wipe workspace
rm(list = ls())

# Load required package(s)
library(readxl)
library(googledrive)

# Create directory for storing data
dir.create('../temp/')
dir.create('../data/coding/', recursive=T)

# Download raw data
drive_download(as_id('1TU1q_jXhUXsVcyxCr9fYGD9mK6j3he5f'), path = '../temp/coding.xlsx', overwrite=T)

# Clean for public use
df <- read_xlsx('../temp/coding.xlsx')

df <- df[, c('DOI', 'Scraped', 'API','use_data_dumps',
             'scraped data_source')]
df$DOI <- gsub('\n', '', df$DOI)


df$Scraped[is.na(df$Scraped)]<-0
df$API[is.na(df$API)] <- 0
df$use_data_dumps[is.na(df$use_data_dumps)] <- 0

colnames(df) <- tolower(colnames(df))
setnames(df, 'scraped data_source', 'scraped_data_source')

write.csv(df, '../data/coding/coding.csv', row.names=F)
