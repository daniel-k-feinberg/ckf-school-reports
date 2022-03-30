files <- list.files(here::here("data"), full.names = TRUE)

dir.create("reports")
out <- paste0(gsub("\\.csv", "", basename(files)), ".pdf")
outfiles <- here::here("reports", out)

purrr::walk2(files, outfiles, ~{
  rmarkdown::render(
    "school-report-ex.Rmd", 
    output_file = .y,
    params = list(file = .x)
  )
})
