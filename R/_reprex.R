


# Converting mutate_all() to mutate(across()) within map() ------
# https://community.rstudio.com/t/converting-mutate-all-to-mutate-across-within-map/141256
library(dplyr)
library(purrr)
# toy_lst
toy_lst <- list(
  tbl_a = structure(list(
    variable = c("text_value_a", "text_value_a"),
    rownumber = 1:2,
    base = c("Issue unresolved", "Issue unresolved"),
    compare = c("Issue resolved", "Issue resolved")),
    class = c("tbl_df", "tbl", "data.frame"),
    row.names = c(NA, -2L), message = ""),
  tbl_b = structure(list(
    variable = "text_value_b",
    rownumber = 4L,
    base = "Joint pain",
    compare = "Joint pain, stiffness and swelling"),
    class = c("tbl_df","tbl", "data.frame"),
    row.names = c(NA, -1L), message = ""),
  tbl_update = structure(list(
    variable = c("updated_date","updated_date", "updated_date",
      "updated_date", "updated_date"),
    rownumber = 1:5,
    base = structure(c(18899, 18903, 18872, 18903, 18890), class = "Date"),
    compare = structure(c(18903,18958, 18920, 18913, 18914), class = "Date")),
    class = c("tbl_df","tbl", "data.frame"),
    row.names = c(NA, -5L), message = ""),
  tbl_entdate = structure(list(
    variable = c("entered_date", "entered_date", "entered_date",
      "entered_date", "entered_date"),
    rownumber = 1:5,
    base = structure(c(18899, 18929, 18857,18903, 18920), class = "Date"),
    compare = structure(c(18961, 18961, 18952, 18942, 18947), class = "Date")),
    class = c("tbl_df", "tbl", "data.frame"),
    row.names = c(NA, -5L), message = "")
)
# view toy list
toy_lst
# this converts all to character
map(.x = toy_lst, .f = mutate_all, as.character)
# but how to use mutate() + across() + as.character()?
# as another argument?
map(.x = toy_lst, .f = mutate, across, as.character)
# as a list?
map(.x = toy_lst, .f = mutate, list(across, as.character))
# maybe in the reverse order?
map(.x = toy_lst, .f = mutate, list(as.character, across))
