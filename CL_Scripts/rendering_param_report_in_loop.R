render_one <- function(csv_file_name) {
  # assuming the output format of input.Rmd is PDF
  
  school_name <- gsub("SAISD-",  "", gsub("\\.csv", "", csv_file_name))
  
  rmarkdown::render(
    input = 'school-report-template.Rmd',
    output_dir = 'April-7-school-reports',
    output_file = paste0(school_name, '-report', '.pdf'),
    params = 
      list(
        file = paste0('data/', csv_file_name)
        ),
    envir = parent.frame()
  )
}
## `schls` made from this file: download-sm-data-april15-reporting.R
for (csv_file_name in schls) {
  render_one(csv_file_name)
}

