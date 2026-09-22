test_that("mod_display_server() previews base and compare data from mod_upload_server()'s return shape", {
  data_upload <- list(
    base_data = shiny::reactive(InitialData),
    base_name = shiny::reactive("InitialData"),
    comp_data = shiny::reactive(ChangedData),
    comp_name = shiny::reactive("ChangedData")
  )

  shiny::testServer(
    mod_display_server,
    args = list(data_upload = data_upload),
    {
      session$flushReact()

      expect_true(grepl("InitialData", paste(output$base_data_name, collapse = "")))
      expect_true(grepl("ChangedData", paste(output$comp_data_name, collapse = "")))
      expect_false(is.null(output$base_data_display))
      expect_false(is.null(output$comp_data_display))
    }
  )
})
