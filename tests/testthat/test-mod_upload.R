test_that("mod_upload_server() reads an uploaded base file into base_data()", {
  base_path <- system.file("extdata/csv/InitialData.csv", package = "dfdiffs")

  shiny::testServer(mod_upload_server, {
    session$setInputs(
      base_file = data.frame(
        name = "InitialData.csv",
        size = file.info(base_path)$size,
        type = "text/csv",
        datapath = base_path,
        stringsAsFactors = FALSE
      ),
      base_xlsx_sheets = "",
      base_new_name = "InitialData"
    )

    out <- session$returned$base_data()
    expect_s3_class(out, "data.frame")
    expect_equal(nrow(out), 5)
    expect_true("subject_id" %in% names(out))
  })
})

test_that("mod_upload_server() reads an uploaded compare file into comp_data()", {
  comp_path <- system.file("extdata/csv/ChangedData.csv", package = "dfdiffs")

  shiny::testServer(mod_upload_server, {
    session$setInputs(
      comp_file = data.frame(
        name = "ChangedData.csv",
        size = file.info(comp_path)$size,
        type = "text/csv",
        datapath = comp_path,
        stringsAsFactors = FALSE
      ),
      comp_xlsx_sheets = "",
      comp_new_name = "ChangedData"
    )

    out <- session$returned$comp_data()
    expect_s3_class(out, "data.frame")
    expect_equal(nrow(out), 5)
    expect_true("subject_id" %in% names(out))
  })
})

test_that("mod_upload_server() reads an uploaded xlsx sheet into base_data()", {
  xlsx_path <- withr::local_tempfile(fileext = ".xlsx")
  openxlsx::write.xlsx(InitialData, xlsx_path, sheetName = "InitialData")

  shiny::testServer(mod_upload_server, {
    session$setInputs(
      base_file = data.frame(
        name = "InitialData.xlsx",
        size = file.info(xlsx_path)$size,
        type = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        datapath = xlsx_path,
        stringsAsFactors = FALSE
      ),
      base_xlsx_sheets = "InitialData",
      base_new_name = "InitialData"
    )

    out <- session$returned$base_data()
    expect_s3_class(out, "data.frame")
    expect_equal(nrow(out), nrow(InitialData))
    expect_true("subject_id" %in% names(out))
  })
})

test_that("mod_upload_server() uses base_new_name for base_name() when supplied", {
  base_path <- system.file("extdata/csv/InitialData.csv", package = "dfdiffs")

  shiny::testServer(mod_upload_server, {
    session$setInputs(
      base_file = data.frame(
        name = "InitialData.csv",
        size = file.info(base_path)$size,
        type = "text/csv",
        datapath = base_path,
        stringsAsFactors = FALSE
      ),
      base_new_name = "InitialData"
    )

    expect_equal(session$returned$base_name(), "InitialData")
  })
})
