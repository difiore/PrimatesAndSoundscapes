library(tidyverse)
library(data.table)
library(caret)


data <- read_csv("consolidated_completedata_output.csv", col_names = TRUE)

output <- data %>%
  group_by(audiofile, species) %>%
  summarize(max.avg = mean(max.score),
            min.avg = mean(min.score))

output <- output %>% pivot_wider(., names_from=c("species"), values_from = c("min.avg", "max.avg"))

threshhold <- 4

output <- output %>% mutate(detection1 =
                              if_else(max.avg_T >= threshhold & max.avg_H < threshhold, TRUE, FALSE),
                            detection2 =
                              if_else(max.avg_T >= threshhold & max.avg_T > max.avg_H, TRUE, FALSE)
                            )
sum(output$detection1)
sum(output$detection2)

setnames(data,'species','AutomatedDetections')
setnames(data,'PrimateSpecies','ManualDetections')

# Next steps: create confusion matrix. We want to know how many false-positives,
  # false-negatives, true-positives and true-negatives we have. Use 'caret' package.
  # https://www.journaldev.com/46732/confusion-matrix-in-r

# 1. Turn data in 'AutomatedDetections' column into 1 and 0 values (1 = detection, 0 = no detection)
# 2. Do same for 'ManualDetections' column.
# 3. Create confusion matrix following code in link below.

# 4. Not change all manual detections with distance 4 to 0 values in
  # 'ManualDetections' column so we can assess accuracy of model on only closer calls.
# 5. Create new confusion matrix.
