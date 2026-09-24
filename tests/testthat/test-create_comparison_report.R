test_that("create_comparison_report() writes all six sheets to the xlsx file", {
  out_file <- withr::local_tempfile(fileext = ".xlsx")

  create_comparison_report(
    compare = Roster2022,
    base = Roster2021,
    by = "subject_id",
    file = out_file
  )

  expect_true(file.exists(out_file))
  sheets <- openxlsx::getSheetNames(out_file)
  expect_setequal(
    sheets,
    c("New Data", "Deleted Data", "Changed Data", "Review Changes", "Base Data", "Compare Data")
  )

  new_sheet <- openxlsx::read.xlsx(out_file, sheet = "New Data")
  expect_gt(nrow(new_sheet), 0)
})
