# april 27 report

s <- 
  c('Callaway',
    'El Toyon',
    'Heather Ridge',
    'Jackson Primary',
    'Landmark Middle',
    'MLK Jr. Middle',
    'Newcomer International Center',
    'Northeast Bradford',
    'Pittsburgh Grandview',
    # it for some reason will not pick up dixon even if the EXACT string is supplied
    #'Dixon Intermediate',
    'Sonoma Heights',
    'Talbott Springs'
)



## Download Surveymonkey Data April 7

library(surveymonkey)
library(tidyverse)
## get rows of ready schools


# token for surveymonkey
options(sm_oauth_token = Sys.getenv("sm_oauth_token"))

# pull 1000
tmp <- browse_surveys(1000)

school_indices <- 
  map_dbl(
    .x = s,
    .f = 
      ~which(
       str_detect(string = tmp$title, pattern = 'Kindness Survey') &
         str_detect(string = tmp$title, pattern = .x)
        )
  )
school_indices <- c(5, school_indices)
# confirm names
tmp$title[school_indices]

# subset
april_22_schools <- 
  tmp %>% 
  slice(school_indices)

# fetching
surveys <- map(april_22_schools$id, fetch_survey_obj)
surveys_parsed <- map(surveys, parse_survey)

# data directory
#dir.create("data")

# naming & saving
schls <- gsub("Kindness Survey", "", april_22_schools$title)
schls <- gsub("\\W", "-", schls)
schls <- gsub("-$", ".csv", schls)

filenames <- here::here("data", schls)

walk2(surveys_parsed, filenames, readr::write_csv)

### spanish

spanish_index <- 
  which(
    str_detect(string = tmp$title, pattern = 'Newcomer International Center') &
      str_detect(string = tmp$title, pattern = 'sobre la bondad') 
  )
april_22_spanish <- 
  tmp %>% slice(spanish_index)
spanish_survey <- fetch_survey_obj(april_22_spanish$id)
spanish_parsed <- parse_survey(spanish_survey)

schls_spanish <- gsub("sobre la bondad", "", april_22_spanish$title)
schls_spanish <- gsub("\\W", "-", schls_spanish)
schls_spanish <- gsub("-$", ".csv", schls_spanish)

filenames <- here::here("data", schls_spanish)

walk2(surveys_parsed, filenames, readr::write_csv)
