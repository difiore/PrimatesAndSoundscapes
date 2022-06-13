# Packages needed:
library(tidyverse)

# Import data:
data <- "duet_locations_summer_2016.csv"

# Coordinates for SM2 recorder
recorder_point <- tibble(x = 371615.842384814, y = 9929386.74684912)

d <- read_csv(data, col_names = TRUE)
d <- d %>% mutate(xdisp = sin(Deg*pi/180), ydisp = cos(Deg*pi/180)) %>%
  mutate(Titis_UTM_X = Loc_UTM_X + xdisp, Titis_UTM_Y=Loc_UTM_Y + ydisp) %>%
  mutate(dist_to_recorder = sqrt((Titis_UTM_X-recorder_point$x)^2 + (Titis_UTM_Y - recorder_point$y)^2))

write_csv(d, "duet_locations_summer_2016_distance.csv")

plot(d$dist_to_recorder, d$SNR_dB,
     main='Distance vs SNR',
     xlab='Distance to Recorder', ylab='Signal-to-Noise Ratio')
abline(lm(SNR_dB ~ dist_to_recorder, data = d), col = "blue")
