# Automated Detection Algorithm - Template Matching using Monitor's Spectrogram Cross Correlation
# Authors: Silvy van Kuijk & Sun O'Brien
# Modifications: Anthony Di Fiore 2022-07-03


#-----------

#To install packages, use this:

install = FALSE

if(install) {
  install.packages("monitoR")
  install.packages("tuneR")
  install.packages("foreach")
}

#Call the package into R's memory:
library(monitoR)
library(tuneR)
library(foreach)

# Get a list of all files in AutomatedDetection_CreatingTemplates directory...
fileList <- list.files(path = "AutomatedDetection_CreatingTemplates", full.names = TRUE)

# Read in .wav file and create templates... here, files on which templates are based are hard coded to prevent indexing problems...
# Note that `sunwave <-` lines are unecessary for template creation
sunwave <- readWave("AutomatedDetection_CreatingTemplates/TestSample_001.wav")
template1b <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_001.wav", frq.lim = c(0.3, 1.6), t.lim = c(25, 35), name = "F1b,025,-25,T", amp.cutoff = (-25))

sunwave <- readWave("AutomatedDetection_CreatingTemplates/TestSample_002.wav")
template2b1 <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_002.wav", frq.lim = c(0.2, 1.8), t.lim = c(0, 10), name = "F2b,000,-25,T", amp.cutoff = (-25))
template2b2 <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_002.wav", frq.lim = c(0.2, 1.8), t.lim = c(87, 97), name = "F2b,087,-25,T", amp.cutoff = (-25))

sunwave <- readWave("AutomatedDetection_CreatingTemplates/TestSample_003.wav")
template3b <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_003.wav", frq.lim = c(0.2, 1.8), t.lim = c(0, 10), name = "F3b,000,-25,T", amp.cutoff = (-25))

sunwave <- readWave("AutomatedDetection_CreatingTemplates/TestSample_004.wav")
template4b1 <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_004.wav", frq.lim = c(0.2, 1.4), t.lim = c(0, 10), name = "F4b,000,-25,T", amp.cutoff = (-25))
template4b2 <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_004.wav", frq.lim = c(0.2, 1.8), t.lim = c(30, 40), name = "F4b,030,-25,T", amp.cutoff = (-25))

sunwave <- readWave("AutomatedDetection_CreatingTemplates/TestSample_005.wav")
template5b <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_005.wav", frq.lim = c(0.2, 1.4), t.lim = c(65, 75), name = "F5b,065,-25,T", amp.cutoff = (-25))

sunwave <- readWave("AutomatedDetection_CreatingTemplates/TestSample_006.wav")
template6b <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_006.wav", frq.lim = c(0.2, 1.0), t.lim = c(15, 25), name = "F6b,015,-25,H", amp.cutoff = (-25))

sunwave <- readWave("AutomatedDetection_CreatingTemplates/TestSample_007.wav")
template7b <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_007.wav", frq.lim = c(0.2, 1.4), t.lim = c(17, 27), name = "F7b,017,-25,H", amp.cutoff = (-25))

sunwave <- readWave("AutomatedDetection_CreatingTemplates/TestSample_008.wav")
template8b1 <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_008.wav", frq.lim = c(0.3, 1.5), t.lim = c(25, 35), name = "F8b,025,-25,T", amp.cutoff = (-25))
template8b2 <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_008.wav", frq.lim = c(0.3, 1.5), t.lim = c(36, 46), name = "F8b,036,-25,T", amp.cutoff = (-25))

sunwave <- readWave("AutomatedDetection_CreatingTemplates/ManualRecording3_REC0083.wav")
templateManual <- makeBinTemplate("AutomatedDetection_CreatingTemplates/ManualRecording3_REC0083.wav", frq.lim = c(0.2, 1.8), t.lim = c(102, 112), name = "F0b,102,-25,T", amp.cutoff = (-25))

# Create combined template bin...
ctemps_adjusted_amp <- combineBinTemplates(template1b, template2b1, template2b2, template3b, template4b1, template4b2, template5b, template8b1, template8b2, template6b, template7b, templateManual)

# Tony's alternative...
library(tidyverse)
library(lubridate)
# Get list all .wav files in the test dataset...
audioFileList <- tibble(f = list.files(path = "~/Desktop/For Sun - Full test dataset", full.names = TRUE, recursive = TRUE)) # lists all of files recursively
# Get a datetime for each file based on base file name in path and reformat into a datetime...
audioFileList <- audioFileList %>% mutate(date = str_extract(basename(f),"_[0-9]+_"))
audioFileList <- audioFileList %>% mutate(date = str_sub(date,-9, -2))
audioFileList <- audioFileList %>% mutate(date = as.Date(date,"%Y%m%d"))
audioFileList <- audioFileList %>% mutate(time = str_extract(f,"[0-9]+.wav"))
audioFileList <- audioFileList %>% mutate(hh = str_sub(time,-10, -9), mm = str_sub(time, -8,-7), ss = str_sub(time, -6, -5))
audioFileList <- audioFileList %>% mutate(datetime = make_datetime(year = year(date), month = month(date), day = day(date), hour = hh, min = mm, sec = ss))
# Get rid of extraneous columns
audioFileList <- audioFileList %>% select(-c(date, time, hh, mm, ss))
# Filter down to include those files up to 08:00 am, inclusive...
audioFileList <- audioFileList %>% filter(hour(datetime) * 60 + minute(datetime) <= 480) # 08:00 am is 480 minutes after midnight
# Get plot and year info and recording location info from file path...
audioFileList <- audioFileList %>% mutate(plot_year = str_split(f, "/")[[1]][6])
audioFileList <- audioFileList %>% mutate(location = str_split(f, "/")[[1]][7])
# Create a new list of all unique directories that these files are found in...
dirList <- audioFileList %>% mutate(dir = dirname(f)) %>% select(dir) %>% unique()

testfiles <- 3

outfile <- "output.txt"

sink(file = outfile)

# Loop through all .wav files and run binMatch()
for (i in 1:nrow(audioFileList[1:testfiles,])) {
  print("------------")
  print(paste("folder_path:", dirname(audioFileList[i,]$f)))
  print(paste("filename:", basename(audioFileList[i,]$f)))
  print(paste("plot_year:", audioFileList[i,]$plot_year))
  print(paste("location:", audioFileList[i,]$location))
  print(paste("datetime:", audioFileList[i,]$datetime))
  scores <- binMatch(audioFileList[i,]$f, ctemps_adjusted_amp, quiet = TRUE)
  print(scores)
}

sink()
