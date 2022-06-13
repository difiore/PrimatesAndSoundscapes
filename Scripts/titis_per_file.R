library(tidyverse)
library(caret)
library(data.table)


# Data for Confusion Matrix 1 - Distances 1 - 4.
Data <- read_csv("Primates_In_All_Recordings.csv", col_names = TRUE)

Data$Titis <- if_else(Data$PrimateSpecies== "Titi", TRUE, FALSE)

TitisInRecording <- Data %>% group_by(audiofile, location) %>% summarise(TitiCount = sum(Titis))

TitisInRecording$TitisPresent <- ifelse(TitisInRecording$TitiCount >= 1, "1", "0")

TitisInRecording <- TitisInRecording[, c(1, 2, 4)]

write_csv(TitisInRecording, "TitisInRec.csv")


SunsData <- read_csv("final_output.csv", col_names = TRUE)
setnames(SunsData,'original_output_file','audiofile')
setnames(SunsData, 'confusion_matrix_number', 'automated_detection')


SilvysData <- read_csv("TitisInRec.csv", col_names = TRUE)
setnames(SilvysData, 'TitisPresent', 'manual_detections')

Merged_tables <- left_join(SunsData, SilvysData, by = c("audiofile" = "audiofile"))
Merged_tables <- Merged_tables[, c(1, 2, 3, 4, 6, 5, 7)]
write_csv(Merged_tables, "manual_vs_automated_dist_1to4.csv")

matrix <- confusionMatrix(data=as.factor(Merged_tables$automated_detection), reference = as.factor(Merged_tables$manual_detections))
matrix


# Data for Confusion Matrix 2 - Distances 1-3 only.
Data2 <- read_csv("Primates_In_All_Recordings.csv", col_names = TRUE)

Data2$Titis <- if_else(Data2$PrimateSpecies== "Titi", TRUE, FALSE)

Data2$Titis[Data2$CallDistance == '4'] <- FALSE

TitisInRecording2 <- Data2 %>% group_by(audiofile, location) %>% summarise(TitiCount = sum(Titis))

TitisInRecording2$TitisPresent <- ifelse(TitisInRecording2$TitiCount >= 1, "1", "0")

TitisInRecording2 <- TitisInRecording2[, c(1, 2, 4)]

write_csv(TitisInRecording2, "TitisInRec2.csv")

SunsData <- read_csv("final_output.csv", col_names = TRUE)
setnames(SunsData,'original_output_file','audiofile')
setnames(SunsData, 'confusion_matrix_number', 'automated_detection')


SilvysData <- read_csv("TitisInRec2.csv", col_names = TRUE)
setnames(SilvysData, 'TitisPresent', 'manual_detections')

Merged_tables2 <- left_join(SunsData, SilvysData, by = c("audiofile" = "audiofile"))
Merged_tables2 <- Merged_tables2[, c(1, 2, 3, 4, 6, 5, 7)]

write_csv(Merged_tables2, "manual_vs_automated_dist_1to3.csv")


matrix2 <- confusionMatrix(data=as.factor(Merged_tables2$automated_detection), reference = as.factor(Merged_tables2$manual_detections))
matrix2

sum(Merged_tables$manual_detections, na.rm = TRUE)
sum(Merged_tables2$manual_detections, na.rm = TRUE)

m <- glm(manual_detections~ avg_titi_max_score + avg_howler_max_score,
         data = Merged_tables2,
         family = "binomial")

m2 <- glm(manual_detections~ avg_titi_max_score,
         data = Merged_tables2,
         family = "binomial")

summary(m)
summary(m2)
