library(tidyverse)
library(ggplot2)


# pull in processed output files from template run
template_output <- read_csv("consolidated_completedata_output.csv", show_col_types = FALSE, skip_empty_rows = TRUE)

# create output tibble for results
results <- tibble(
  original_output_file=character(),
  detection=character(),
  avg_titi_max_score=numeric())

line_count = nrow(template_output) + 1     # for some reason it excludes the first row. add 1.
num_files = line_count / 12     # we use twelve templates at the moment

# loop by file name
    # loop by template number

detection_threshold = 4

file_num = 1
line_num = 1
while(file_num <= num_files) { # 80 files
  titi_template_sum = 0
  howler_template_sum = 0
  r <- tibble(
    original_output_file=character(),
    detection=character(),
    avg_titi_max_score=numeric())

  original_output_file <- character()
  detection <- character()
  avg_titi_max_score <- numeric()

  file_name = template_output[[5]][line_num]

  for(x in 1:12) { # 12 templates/file
    print(template_output[[5]][line_num])
    if(template_output[[9]][line_num] == "T") {
      #print("titi")
      titi_template_sum = titi_template_sum + template_output[[11]][line_num]
    } else { # howler template
      #print("howler")
      howler_template_sum = howler_template_sum + template_output[[11]][line_num]
    }
    line_num = line_num + 1
  }

  titi_template_sum = titi_template_sum / 10      # 10 titi templates
  howler_template_sum = howler_template_sum / 2   # 2 howler templates

  print("-")
  print(paste("file num", file_num))
  print(paste("titi avg", titi_template_sum))
  print(paste("howler avg", howler_template_sum))
  print("-")

  if(titi_template_sum >= detection_threshold & howler_template_sum < detection_threshold) {
    # titi detection (positive)
    r <- tibble(original_output_file=file_name, detection="positive", avg_titi_max_score=titi_template_sum)
  } else {
    # no detection (negative)
    r <- tibble(original_output_file=file_name, detection="negative", avg_titi_max_score=titi_template_sum)
  }
  results <- bind_rows(results, r)
  file_num = file_num + 1
}

write_csv(results, "final_output.csv")

