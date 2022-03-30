library(surveymonkey)
library(purrr)

options(sm_oauth_token = Sys.getenv("sm_oauth_token"))

tmp <- browse_surveys(1000)
aisd <- tmp %>% 
  dplyr::filter(grepl("^AISD", title))

surveys <- map(aisd$id, fetch_survey_obj)
surveys_parsed <- map(surveys, parse_survey)

dir.create("data")

schls <- gsub("Kindness Survey", "", aisd$title)
schls <- gsub("\\W", "-", schls)
schls <- gsub("-$", ".csv", schls)

filenames <- here::here("data", schls)

walk2(surveys_parsed, filenames, readr::write_csv)
