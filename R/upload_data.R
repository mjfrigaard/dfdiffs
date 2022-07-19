#' Load flat data files
#'
#' @param path path to data file (with extension)
#'
#' @return return_data as loaded flat file
#'
#' @export load_flat_file
#'
#' @importFrom data.table fread
#' @importFrom haven read_sas
#' @importFrom haven read_sav
#' @importFrom haven read_dta
#' @importFrom tools file_ext
#' @importFrom tibble as_tibble
load_flat_file <- function(path) {
  ext <- tools::file_ext(path)
  data <- switch(ext,
    txt = data.table::fread(path),
    csv = data.table::fread(path),
    tsv = data.table::fread(path),
    sas7bdat = haven::read_sas(data_file = path),
    sas7bcat = haven::read_sas(data_file = path),
    sav = haven::read_sav(file = path),
    dta = haven::read_dta(file = path)
  )
  return_data <- tibble::as_tibble(data)
  return(return_data)
}

#' Upload data files
#'
#' @param path path to data file (with extension)
#' @param sheet excel sheet (if excel file)
#'
#' @return uploaded data file
#'
#' @export upload_data
#' @importFrom readxl read_excel
#' @importFrom tools file_ext
#' @importFrom tibble as_tibble
#'
upload_data <- function(path, sheet = NULL) {
  ext <- tools::file_ext(path)
  if (ext == "xlsx") {
    raw_data <- readxl::read_excel(
        path = path,
        sheet = sheet
      )
    uploaded <- tibble::as_tibble(raw_data)
  } else {
    uploaded <- load_flat_file(path = path)
  }
  return(uploaded)
}
