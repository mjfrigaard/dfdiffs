#' Load flat data files
#'
#' @param path path to data file (with extension)
#'
#' @return return_data
#' @export load_flat_file
#'
#' @examples # from local
#' load_flat_file(path = "inst/extdata/csv/2015-baseballdatabank/core/AllstarFull.csv")
#'
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
  return_data <- as_tibble(data)
  return(return_data)
}
