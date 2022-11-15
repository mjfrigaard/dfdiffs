#' Extract tables from `diffdf::diffdf` list
#'
#' @param diffdf_list output from `diffdf::diffdf()` function
#' @param by_keys `keys` argument from `diffdf::diffdf()`/`by` argument from
#'      `create_changed_data()`
#'
#' @importFrom stringr str_detect
#' @importFrom dplyr mutate
#' @importFrom stringr str_detect
#' @importFrom purrr map_df
#' @importFrom purrr map
#' @importFrom janitor clean_names
#' @importFrom purrr set_names
#' @importFrom dplyr across
#' @importFrom dplyr select
#' @importFrom dplyr contains
#' @importFrom dplyr relocate
#' @importFrom dplyr row_number
#' @importFrom tibble as_tibble
#' @importFrom tidyr unite
#' @importFrom tidyr unnest
#' @importFrom magrittr `%>%`
#'
#' @return diff_tbls list of diff tables
#' @export extract_df_tables
#'
#' @description This is a sub-function for create_changed_data()
extract_df_tables <- function(diffdf_list, by_keys) {
  diff_lst_nms <- base::names(diffdf_list)
  num_diffs_lst <- diffdf_list[stringr::str_detect(diff_lst_nms, "Num")]
  var_diffs_lst <- diffdf_list[stringr::str_detect(diff_lst_nms, "Var")]
  base_diffs_lst <- diffdf_list[stringr::str_detect(diff_lst_nms, "Base")]
  comp_diffs_lst <- diffdf_list[stringr::str_detect(diff_lst_nms, "Comp")]
  # nums
  num_diffs <- purrr::map_df(.x = num_diffs_lst,
                                  .f = janitor::clean_names)
  # vars
  var_diffs_chr_lst <- purrr::map(var_diffs_lst,
                            .f = ~dplyr::mutate(.x,across(.cols = everything(),
                                                    .fns = as.character)))
  var_diffs <- purrr::map_df(.x = var_diffs_chr_lst, .f = janitor::clean_names)

  if (length(base_diffs_lst) > 0 & length(comp_diffs_lst) > 0) {
    # base & comps
    base_diffs_issue <- tibble::as_tibble(base_diffs_lst)
    base_diffs <- tidyr::unnest(base_diffs_issue, ExtRowsBase)
    base_diffs <- purrr::set_names(x = base_diffs,
                    nm = paste0(by_keys, "s in BASE that are not in COMPARE"))
    comp_diffs_issue <- tibble::as_tibble(comp_diffs_lst)
    comp_diffs <- tidyr::unnest(comp_diffs_issue, ExtRowsComp)
    comp_diffs <- purrr::set_names(x = comp_diffs,
                      nm = paste0(by_keys, "s in COMPARE that are not in BASE"))
    diff_tbls <- list(
      "base_diffs" = base_diffs, "comp_diffs" = comp_diffs,
      "num_diffs" = num_diffs, "var_diffs" = var_diffs
      )
  } else if (length(base_diffs_lst) > 0 & length(comp_diffs_lst) == 0) {
    # base
    base_diffs_issue <- tibble::as_tibble(base_diffs_lst)
    base_diffs <- tidyr::unnest(base_diffs_issue, ExtRowsBase)
    base_diffs <- purrr::set_names(x = base_diffs,
                    nm = paste0(by_keys, "s in BASE that are not in COMPARE"))
    diff_tbls <- list(
      "base_diffs" = base_diffs,
      "num_diffs" = num_diffs, "var_diffs" = var_diffs
      )
  } else if (length(base_diffs_lst) == 0 & length(comp_diffs_lst) > 0) {
    # comps
    comp_diffs_issue <- tibble::as_tibble(comp_diffs_lst)
    comp_diffs <- tidyr::unnest(comp_diffs_issue, ExtRowsComp)
    comp_diffs <- purrr::set_names(x = comp_diffs,
                      nm = paste0(by_keys, "s in COMPARE that are not in BASE"))
    diff_tbls <- list(
      "comp_diffs" = comp_diffs,
      "num_diffs" = num_diffs, "var_diffs" = var_diffs,
      )
  } else {
    diff_tbls <- list(
      "num_diffs" = num_diffs,
      "var_diffs" = var_diffs)
  }
  return(diff_tbls)
}
