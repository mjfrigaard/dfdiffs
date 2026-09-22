test_that("mod_compare_server() detects changed values via the 'join_column' path", {
  base_joined <- create_join_column(
    df = InitialData,
    by_colums = c("subject_id", "record"),
    new_by_column_name = "join_column"
  )
  base_joined <- tibble::add_column(base_joined, data_source = "InitialData", .after = 1)
  base_joined <- tibble::add_column(base_joined, join_source = "subject_id-record", .after = 1)

  comp_joined <- create_join_column(
    df = ChangedData,
    by_colums = c("subject_id", "record"),
    new_by_column_name = "join_column"
  )
  comp_joined <- tibble::add_column(comp_joined, data_source = "ChangedData", .after = 1)
  comp_joined <- tibble::add_column(comp_joined, join_source = "subject_id-record", .after = 1)

  data_selected <- list(
    base_join_col_data = shiny::reactive(base_joined),
    comp_join_col_data = shiny::reactive(comp_joined)
  )

  shiny::testServer(
    mod_compare_server,
    args = list(data_selected = data_selected),
    {
      expect_true("join_column" %in% compare_cols())

      changed <- changed_data()
      expect_true(all(c("diffs", "diffs_byvar") %in% names(changed)))
      expect_gt(nrow(changed$diffs_byvar), 0)

      new <- new_data()
      deleted <- deleted_data()
      expect_equal(nrow(new), 0)
      expect_equal(nrow(deleted), 0)
    }
  )
})
