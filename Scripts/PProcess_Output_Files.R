# script to parse all .txt files in a "data" folder of output files
# and return a .csv file with the desired elements

library(tidyverse)
library(ggplot2)
library(data.table)

filenames <- list.files(
  "Output_ManualData", pattern = ".txt", full.names = TRUE
)
# initialize results
results <- tibble(
  original_output_file=character(),
  survey_file_name=character(),
  template=character(),
  min.score=numeric(),
  max.score=numeric(),
  n.scores=numeric())

for (f in filenames){
  # initialize r
  r <- tibble(
    original_output_file=character(),
    survey_file_name=character(),
    template=character(),
    min.score=numeric(),
    max.score=numeric(),
    n.scores=numeric())
  d <- read_lines(f, skip_empty_rows = TRUE)
  # initialize vectors
  survey_file_name <- character()
  folder <- character()
  location <- character()
  recording.date <- character()
  audiofile <- character()
  template <- character()
  min.score <- numeric()
  max.score <- numeric()
  n.scores <- numeric()
  # initialize index
  index <- 0
  for (i in 1:length(d)){ # loop through file line by line
    if (str_detect(d[i], "Based") ==TRUE){
      fname <- str_remove(d[i], "Based on the survey file:  [a-zA-Z -]*/")
      fname <- str_remove(fname, " $")
      locationSubstrings <- str_split(fname, "/")
      folder <- locationSubstrings[[1]][1]
      location <- locationSubstrings[[1]][2]
      recording.date <- locationSubstrings[[1]][3]
      audiofile <- locationSubstrings[[1]][4]
      filename <- paste0(fname)
    }
    l <- str_split(d[i], "[ ]+")

    if (str_detect(l[[1]][1], "F") ==TRUE){
      index <- index + 1
      survey_file_name[index] <- filename
      template[index] <- l[[1]][1]
      min.score[index] <- as.numeric(l[[1]][2])
      max.score[index] <- as.numeric(l[[1]][3])
      n.scores[index] <- as.numeric(l[[1]][4])
    }
  }
  r <- tibble(
    original_output_file=f,
    survey_file_name=survey_file_name,
    folder=folder,
    location=location,
    recording.date=recording.date,
    audiofile=audiofile,
    template=template,
    min.score=min.score,
    max.score=max.score,
    n.scores=n.scores
  )
  results <- bind_rows(results, r)
  # cleanup memory and work space
  rm(list=c(
    "r",
    "d",
    "l",
    "survey_file_name",
    "folder",
    "location",
    "recording.date",
    "audiofile",
    "template",
    "min.score",
    "max.score",
    "n.scores",
    "index",
    "i",
    "filename"
  ))
}

#Separate data that are currently merged in a single column
results <- separate(data = results, col = "template",
                    into = c("template", "starttime", "ampcutoff", "species"),
                    sep = ",")

#Reorder columns and remove some obsolete columns.
results <- results[, c(13, 10, 11, 12, 3, 4, 5, 6, 7, 8, 9)]

#Problems are about to appear, so let's gather some extra data:
str(results) #This shows us the 'audiofile' column is a string.

#Load in next file. The file 'PrimatesInFiles' notes which audio files had
  # primate calls found by manual observers. NOTE: Not every line in this file
  # is a unique recording. There are duplicates where a recording had multiple
  # titi and/or howler calls in it.
PrimatesInFiles <- read_csv("Primates_In_All_Recordings.csv", col_names = TRUE)
str(PrimatesInFiles)
# 'audiofile' again seems to be a character.


# Here's the problem: merging these tables does not lead to the desired results.
Merged_tables <- left_join(results, PrimatesInFiles, by = c("audiofile" = "audiofile"))

fwrite(Merged_tables, "consolidated_completedata_output.csv") #The usual write_csv() only wrote the first 600 lines rather than all 14000+!

# cleanup memory and work space
rm(list=c("results", "filenames","f"))


