library(tidyverse)
library(data.table)


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


