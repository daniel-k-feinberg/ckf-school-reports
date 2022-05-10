## Download Surveymonkey Data May 6

library(surveymonkey)
library(tidyverse)
# token for surveymonkey
options(sm_oauth_token = Sys.getenv("sm_oauth_token"))
# confirm this set it
#getOption("sm_oauth_token")
# pull 1000
tmp <- browse_surveys(1000)

# confirm names
tmp$title[school_indices]



## DON'T FORGET THIS ONE 
# 'SAISD Lowell (Oct & Feb responses)')

s <- 
  c(
  #'Ashworth',
  #'Bagdad',
  #'Biloxi',
  #'Button',
  #'SAISD Booker T. Washington',
  #'Morristown', # see note re: morristown below
  'Adams Hill',
  'Centennial',
  'Centennial Lane',
  'Centreville',
  'Churchill County Middle',
  'Clute Intermediate',
  'Dodge Park Elementary',
  'Dolph Briscoe',
  'Great Mills',
  'Green Holly Elementary',
  'Hephzibah High',
  'Homewood Center',
  'Intermediate Unit 1 Campus at Laboratory',
  'Kate Smith',
  'Lake Myrtle',
  'Leake Central',
  'Mary Bethune Alternative',
  'Mill Hall',
  'Pearl River Central Middle',
  'Langford',
  'Mary Bethune Alternative',
  'Mill Hall',
  'Reinhardt Holm',
  'Sheldon Pines OAISD',
  'Social Circle Elementary',
  'Spencer Butte',
  'Sugar Hill',
  'Tyndall Academy',
  'Walterville',
  'Waterville Elysian Morristown',
  'Wyncote',
  'SAISD Ferdinand Herff'
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


may_10_schools <- 
  tmp %>% 
  slice(school_indices) %>% 
# morristown's exact name is contained in another name, so 
# calling the object like this
  bind_rows(
    tmp %>% 
      filter(id == 309757278)
    )

# fetching
surveys <- map(may_10_schools$id, fetch_survey_obj)
surveys_parsed <- map(surveys, parse_survey)

# data directory
#dir.create("data")

# naming & saving
schls <- gsub("Kindness Survey", "", may_10_schools$title)
schls <- gsub("\\W", "-", schls)
schls <- gsub("-$", ".csv", schls)

filenames <- here::here("data", schls)

walk2(surveys_parsed, filenames, readr::write_csv)


