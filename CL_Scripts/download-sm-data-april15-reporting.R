## Download Surveymonkey Data April 7

library(surveymonkey)
library(tidyverse)

# list that was ready for april 11th to DA
s <-
  c('DeLisle', 
    'Economy',
    'Franklin', 
    'Glenellen',
    'Grass Valley',
    'Judge Sylvania Woods',
    'Jupiter',
    'Marsh Creek',
    'Matt',
    'Pioneer Park',
    'Robb',
    'Susie Dasher',
    'Swansfield',
    'Two Rivers Dos Rios',
    'Western Pines',
    'Pershing',
    'Ferdinand Herff')

## get rows of ready schools

school_indices <- 
  map_dbl(
    .x = s,
    .f = 
      ~which(
        str_detect(string = tmp$title, pattern = 'Kindness Survey') &
          str_detect(string = tmp$title, pattern = .x))
  )

# confirm names
tmp$title[school_indices]

# token for surveymonkey
options(sm_oauth_token = Sys.getenv("sm_oauth_token"))

# pull 1000
tmp <- browse_surveys(1000)

# subset

april_7_schools <- 
  tmp %>% 
  slice(school_indices)

# fetching
surveys <- map(april_7_schools$id, fetch_survey_obj)
surveys_parsed <- map(surveys, parse_survey)

# data directory
#dir.create("data")

# naming & saving
schls <- gsub("Kindness Survey", "", april_7_schools$title)
schls <- gsub("\\W", "-", schls)
schls <- gsub("-$", ".csv", schls)

filenames <- here::here("data", schls)

walk2(surveys_parsed, filenames, readr::write_csv)

