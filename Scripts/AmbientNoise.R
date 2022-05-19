#Ambient Noise Measurements
#Author(s): Silvy van Kuijk


#Loading in all necessary components:

setwd('C:/Users/Silvy/Documents/R/Repos/Project3WeatherPatterns')
source("tonyPAMGuide_Meta_revised_AD2.R")
library(boxr)


#Step 1: Connect R to Box and read in all file names in TBS folder.

dir <- "D:/John_Blake_Data"
allfiles <- tibble(filenames=list.files(path=dir,recursive=TRUE,ignore.case=FALSE,pattern=".wav",full.names=TRUE))
head(allfiles)

box_ls() #using boxR package, this should list all files in a certain directory.


#Step 2: Ensure calculations are done on 30-minute segments, not the whole hour.

window_length <- 1800 # new variable to define the length of the window of time being looked at.
d <- d %>% rowwise() %>% mutate(RMSlev_0_2kHz = tonyPAMGuide_Meta(fullfile = paste0(path, "/", FileName), atype= "Broadband", StartTime=StartTime, CallOnset=CallOnset, seconds = window_length, lcut= 200, hcut= 2000, calib= 1, ctype= "TS", Mh=-36, G=0, vADC=1.0, plottype= "Stats", channel = MicUsed)["RMSlev"]) # NOTE: Here channel is assigned to be MicUsed


#Step 3: Pull out all ambient noise measurements for each 10-minute segment, store data in data frame.


#Step 4: Save all data in .csv & create a visualization of the results. 
