test_that("mod_select_server() builds joined base/compare data from selected columns", {
  data_upload <- list(
    base_data = shiny::reactive(InitialData),
    base_name = shiny::reactive("InitialData"),
    comp_data = shiny::reactive(ChangedData),
    comp_name = shiny::reactive("ChangedData")
  )

  shiny::testServer(
    mod_select_server,
    args = list(data_upload = data_upload),
    {
      session$setInputs(
        base_col_select = names(InitialData),
        comp_col_select = names(ChangedData),
        by = c("subject_id", "record")
      )

      base_out <- session$returned$base_join_col_data()
      comp_out <- session$returned$comp_join_col_data()

      expect_s3_class(base_out, "data.frame")
      expect_s3_class(comp_out, "data.frame")
      expect_equal(nrow(base_out), nrow(InitialData))
      expect_equal(nrow(comp_out), nrow(ChangedData))
      expect_true(all(c("join_column", "join_source", "data_source") %in% names(base_out)))
      expect_true(all(c("join_column", "join_source", "data_source") %in% names(comp_out)))
      expect_equal(unique(base_out$data_source), "InitialData")
      expect_equal(unique(comp_out$data_source), "ChangedData")
    }
  )
})

test_that("mod_select_server() falls back to a row-by-row comparison with no 'by' columns", {
  data_upload <- list(
    base_data = shiny::reactive(InitialData),
    base_name = shiny::reactive("InitialData"),
    comp_data = shiny::reactive(ChangedData),
    comp_name = shiny::reactive("ChangedData")
  )

  shiny::testServer(
    mod_select_server,
    args = list(data_upload = data_upload),
    {
      session$setInputs(
        base_col_select = names(InitialData),
        comp_col_select = names(ChangedData)
      )

      base_out <- session$returned$base_join_col_data()

      expect_false("join_column" %in% names(base_out))
      expect_true("data_source" %in% names(base_out))
    }
  )
})
