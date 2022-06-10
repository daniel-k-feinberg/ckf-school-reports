#Tutts, Pocomoke, and Roseland

## Download Surveymonkey Data June 10

library(surveymonkey)
library(tidyverse)
# token for surveymonkey
options(sm_oauth_token = Sys.getenv("sm_oauth_token"))
# confirm this set it
#getOption("sm_oauth_token")
# pull 1000
tmp <- browse_surveys(1000)

s <- 
  c(
    'Tutt',
    'Pocomoke',
    'Roseland'
  )



## get rows of ready schools

school_indices <- 
  map_dbl(
    .x = s,
    .f = 
      ~which(
        str_detect(string = tmp$title, pattern = 'Kindness Survey') &
          str_detect(string = tmp$title, pattern = .x)
      )
  )

#s[unlist(map(school_indices, ~length(.x) == 0))]


june_10_schools <- 
  tmp %>% 
  slice(school_indices)

# fetching
surveys <- map(june_10_schools$id, fetch_survey_obj)
surveys_parsed <- map(surveys, parse_survey)

# data directory
#dir.create("data")

# naming & saving
schls <- gsub("Kindness Survey", "", june_10_schools$title)
schls <- gsub("\\W", "-", schls)
schls <- gsub("-$", ".csv", schls)

filenames <- here::here("data", schls)

walk2(surveys_parsed, filenames, readr::write_csv)


