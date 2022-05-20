library(tidyverse)

Data <- read_csv("Primates_In_All_Recordings.csv", col_names = TRUE)

Data$Titis <- if_else(Data$PrimateSpecies== "Titi", TRUE, FALSE)

TitisInRecording <- Data %>% group_by(audiofile) %>% summarise(TitiCount = sum(Titis))

TitisInRecording$TitisPresent <- ifelse(TitisInRecording$TitiCount >= 1, "1", "0")

