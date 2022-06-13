library(tidyverse)
library(stringr)
library(ggplot2)

# Load in data file.
data <- read_csv("consolidated_completedata_output.csv", col_names = TRUE)

# Two templates were created from files 2 anf 4 (F2 anf F4 in 'template) so we
   # need to create unique names for these templates by merging 'template' and
   # 'starttime' columns.
data$template_time <- str_c(data$template, '_', data$starttime)

# Join with table that contains manual data on recordings
manual_data <- read_csv("Primates_In_All_Recordings.csv", col_names = TRUE)

manual_data <- manual_data %>%
  select(audiofile, PrimateSpecies)

joined_data <- left_join(data, manual_data, by = "audiofile")

template_scores <- joined_data %>% group_by(template_time, PrimateSpecies) %>% summarise(template_average_max = mean(max.score), template_average_min = mean(min.score))

#______________________________

#ggplot(joined_data, aes(x=as.factor(PrimateSpecies), y=max.score)) +
#  geom_boxplot(outlier.colour="red", outlier.shape=16, outlier.size=2) +
#  theme_bw()

ggplot(joined_data, aes(x =max.score, y = ..count.., fill=as.factor(template_time))) +
  geom_histogram(position = "dodge", binwidth = 1, color = "black") +
  ggtitle("Histograms of Humidity per Year") +
  labs(x = "Humidity", y = "Frequency", fill = "Temperature") +
  theme_bw() +
  facet_grid(PrimateSpecies ~ .)
