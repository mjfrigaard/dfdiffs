library(tibble)

# flat_file_curr_data ---------------------------------------------------------
flat_file_curr_data <- tibble::tibble(
  col_a = c(20L, 12L, 18L, 37L),
  col_b = c("l", "m", "n", "o"),
  col_c = c(6.6, 7.1, 4.3, 7.2),
  col_d = c(TRUE, TRUE, FALSE, FALSE)
  )

# flat_file_prev_data ---------------------------------------------------------
flat_file_prev_data <- tibble::tibble(
  col_a = c(20L, 12L, 12L, 12L),
  col_b = c("l", "m", "m", "m"),
  col_c = c(8.3, 4.4, 2.2, 8.9),
  col_d = c(FALSE, FALSE, TRUE, TRUE)
  )

# xlsx_curr_data ---------------------------------------------------------
xlsx_curr_data <- tibble::tibble(
  col_a = c(4L, 3L, 2L, 1L),
  col_b = c("W", "X", "Y", "Z"),
  col_c = c(8.3, 3.3, 22.1, 0.1),
  col_d = c(FALSE, TRUE, FALSE, FALSE)
  )
# xlsx_prev_data ---------------------------------------------------------------
xlsx_prev_data <- tibble::tibble(
  col_a = c(4L, 4L, 2L, 2L),
  col_b = c("W", "W", "Y", "Y"),
  col_c = c(0.5, 1.2, 5.33, 9.1),
  col_d = c(TRUE, FALSE, TRUE, TRUE)
  )
