library(tidyverse)
f <- "consolidated_completedata_output.csv"
d <- read_csv(f, col_names = TRUE)

output <- d %>%
  group_by(survey_file_name, species) %>%
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
