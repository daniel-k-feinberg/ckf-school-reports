## Download Surveymonkey Data May 6

library(surveymonkey)
library(tidyverse)
# token for surveymonkey
options(sm_oauth_token = Sys.getenv("sm_oauth_token"))
# confirm this set it
getOption("sm_oauth_token")
# pull 1000
tmp <- browse_surveys(1000)

# confirm names
tmp$title[school_indices]



## DON'T FORGET THIS ONE 
# 'SAISD Lowell (Oct & Feb responses)')

s <- 
  c('Adams Hill Elementary',
  'Ashworth Elementary',
  'Bagdad Elementary',
  'Biloxi High School',
  'Button Gwinnett Elementary',
  'Centennial Elementary',
  'Centennial Lane Elementary School',
  'Centreville Elementary',
  'Churchill County Middle School',
  'Clute Intermediate School',
  'Dodge Park Elementary School',
  'Dolph Briscoe Middle School',
  'Great Mills High School',
  'Green Holly Elementary School',
  'Hephzibah High School',
  'Homewood Center',
  'Intermediate Unit 1 Campus at Laboratory',
  'Kate Smith Elementary School',
  'Lake Myrtle Elementary',
  'Langford Middle School',
  'Mary Bethune Alternative School',
  'Mill Hall Elementary School',
  'Morristown 5-8',
  'Reinhardt Holm Elementary',
  'Sheldon Pines OAISD',
  'Social Circle Elementary School',
  'Spencer Butte MS',
  'Sugar Hill Elementary School',
  'Tyndall Academy',
  'Walterville Elementary',
  'Waterville Elysian Morristown Elementary',
  'Wyncote Elementary School',
  'SAISD Booker T. Washington',
  'SAISD Ferdinand Herff')
  

## get rows of ready schools

school_indices <- 
  map_dbl(
    .x = s,
    .f = 
      ~which(
        str_detect(string = tmp$title, pattern = 'Kindness Survey') &
          str_detect(string = tmp$title, pattern = .x))
  )


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


