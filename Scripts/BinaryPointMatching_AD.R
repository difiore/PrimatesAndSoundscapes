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
  install.packages("tidyverse")
  install.packages("libridate")
}

#Call the package into R's memory:
library(monitoR)
library(tuneR)
library(foreach)
library(tidyverse)
library(lubridate)

# Get a list of all files in AutomatedDetection_CreatingTemplates directory...
fileList <- list.files(path = "AutomatedDetection_CreatingTemplates", full.names = TRUE)

# Read in .wav file and create templates... here, files on which templates are based are hard coded to prevent indexing problems...
template1b <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_001.wav", frq.lim = c(0.3, 1.6), t.lim = c(25, 35), name = "F1b,025,-25,T", amp.cutoff = (-25))

template2b1 <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_002.wav", frq.lim = c(0.2, 1.8), t.lim = c(0, 10), name = "F2b,000,-25,T", amp.cutoff = (-25))
template2b2 <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_002.wav", frq.lim = c(0.2, 1.8), t.lim = c(87, 97), name = "F2b,087,-25,T", amp.cutoff = (-25))

template3b <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_003.wav", frq.lim = c(0.2, 1.8), t.lim = c(0, 10), name = "F3b,000,-25,T", amp.cutoff = (-25))

template4b1 <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_004.wav", frq.lim = c(0.2, 1.4), t.lim = c(0, 10), name = "F4b,000,-25,T", amp.cutoff = (-25))
template4b2 <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_004.wav", frq.lim = c(0.2, 1.8), t.lim = c(30, 40), name = "F4b,030,-25,T", amp.cutoff = (-25))

template5b <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_005.wav", frq.lim = c(0.2, 1.4), t.lim = c(65, 75), name = "F5b,065,-25,T", amp.cutoff = (-25))

template6b <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_006.wav", frq.lim = c(0.2, 1.0), t.lim = c(15, 25), name = "F6b,015,-25,H", amp.cutoff = (-25))

template7b <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_007.wav", frq.lim = c(0.2, 1.4), t.lim = c(17, 27), name = "F7b,017,-25,H", amp.cutoff = (-25))

template8b1 <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_008.wav", frq.lim = c(0.3, 1.5), t.lim = c(25, 35), name = "F8b,025,-25,T", amp.cutoff = (-25))
template8b2 <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_008.wav", frq.lim = c(0.3, 1.5), t.lim = c(36, 46), name = "F8b,036,-25,T", amp.cutoff = (-25))

template0b <- makeBinTemplate("AutomatedDetection_CreatingTemplates/ManualRecording3_REC0083.wav", frq.lim = c(0.2, 1.8), t.lim = c(102, 112), name = "F0b,102,-25,T", amp.cutoff = (-25))

template9b <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_009.wav", frq.lim = c(0.5, 1.0), t.lim = c(1, 7), name = "F9b,001,-25,S", amp.cutoff = (-25))

template10b <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_010.wav", frq.lim = c(0.5, 1.0), t.lim = c(2, 9), name = "F10b1,002,-25,S", amp.cutoff = (-25))

template11b <- makeBinTemplate("AutomatedDetection_CreatingTemplates/TestSample_011.wav", frq.lim = c(0.7, 1.2), t.lim = c(10, 22), name = "F11b,010,-25,S", amp.cutoff = (-25))


# Create a combined template bin. DON'T RUN BOTH LINES BELOW. CHOOSE WHICH ONE IS APPROPRIATE!

# All templates
ctemps_adjusted_amp <- combineBinTemplates(template1b, template2b1, template2b2, template3b, template4b1, template4b2, template5b, template6b, template7b, template8b1, template8b2, template0b, template9b, template10b, template11b)

# Only spider templates
ctemps_spiders <- combineBinTemplates(template9b, template10b, template11b)

#---

# To locate where in an audio file the high detection scores come from, use this:

bscores <- binMatch("E:/For Sun - Full test dataset/Puma 2016/-2, 0/12 feb/PUMA_20160212_080000.wav", ctemps_adjusted_amp)
bdetects <- findPeaks(bscores)

bdetects # Shows you the highest detection  score for each template.
# To find where in the audio file those were located, use the next line of code:
plot(bdetects)


#---


# Tony's alternative...

# Get list all .wav files in the test dataset...
audioFileList <- data.frame(f = list.files(path = "E:/For Sun - Full test dataset", full.names = TRUE, recursive = TRUE)) # lists all of files recursively

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
audioFileList <- audioFileList %>% rowwise %>% mutate(plot_year = unlist(str_split(f, "/"))[6])
audioFileList <- audioFileList %>% mutate(location = unlist(str_split(f, "/"))[7])

testfiles <- 3 # just runs through a small set of .wav files to test... here, the first 3 in the dataset...

outfile <- "test_output.txt"

sink(file = outfile)

# Loop through all .wav files and run binMatch()
# This code generates ONE output file containing "scores" for each .wav file (n = 1200 total)
for (i in 1:nrow(audioFileList[1:testfiles,])) { # replace `nrow(audioFileList[1:testfiles,]` with `nrow(audioFileList)` to run entire dataset
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


# Alternatively... we can create a list of DIRECTORIES of unique plot-year-locations that these files are found in
# and then loop through this list running binMatch()...
# This should generate one output file for each combination of plot-year-location, with up to 10 files per sampled day
# There are 44 unique plot-year-locations with between 2 and 8 sampled days each
# This is analogous to what Silvy created before, copying code and redoing path for each plot-year-location combination
# Again, there's a total of n = 1200 .wav files between 05:45 and 08:00
dirList <- audioFileList %>% mutate(dir = dirname(f)) %>% rowwise() %>%
  mutate(plot_year = unlist(str_split(dir, "/"))[6]) %>% mutate(location = unlist(str_split(dir, "/"))[7]) %>%
  select(plot_year, location) %>% unique()
nrow(dirList) # 44 unique combinations of plot-year-locations

testdirs <- 2 # just runs through a small set of directories to test... here, the first 2 (out of 44) in the dataset...

for (i in 1:nrow(dirList[1:testdirs,])){ # replace `dirList[1:testdirs,]` with `nrow(dirList)` to run entire dataset
  outfile <- paste0("output_", dirList[i,]$plot_year, "_", dirList[i,]$location, ".txt")
  print(outfile)
  f <- audioFileList %>% filter(plot_year == dirList[i,]$plot_year & location == dirList[i,]$location)
  print(nrow(f))
  sink(file = outfile)
  for (j in 1:nrow(f)){
    scores <- binMatch(f[j,]$f, ctemps_adjusted_amp, quiet = TRUE)
    print(scores)
  }
  sink()
}
