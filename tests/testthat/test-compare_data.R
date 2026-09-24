test_that("compare_data() returns new, deleted, and changed comparison tables", {
  out <- compare_data(
    compare = Roster2022,
    base = Roster2021,
    by = "subject_id",
    cols = c("first_name", "last_name", "full_name", "height_cm")
  )

  expect_named(out, c("new_data", "deleted_data", "changed_num_diffs", "changed_var_diffs"))
  expect_s3_class(out$new_data, "data.frame")
  expect_s3_class(out$deleted_data, "data.frame")
  expect_gt(nrow(out$new_data), 0)
  expect_gt(nrow(out$deleted_data), 0)
})
