test_that("compare_summary() reports row/column counts against a known fixture", {
  out <- compare_summary(compare = Roster2022, base = Roster2021, by = "subject_id")
  expect_s3_class(out, "dfdiffs_summary")
  expect_equal(out$n_base, nrow(Roster2021))
  expect_equal(out$n_compare, nrow(Roster2022))
  expect_equal(out$n_common, 197)
  expect_equal(out$n_new, 40)
  expect_equal(out$n_deleted, 3)
  expect_equal(out$n_vars_common, 11)
  expect_equal(out$n_vars_base_only, 0)
  expect_equal(out$n_vars_compare_only, 0)
})

test_that("compare_summary() reports base/compare-only columns", {
  base <- data.frame(id = 1:3, a = 1:3, only_base = 1:3)
  compare <- data.frame(id = 1:3, a = 1:3, only_compare = 1:3)
  out <- compare_summary(compare = compare, base = base, by = "id")
  expect_equal(out$n_vars_base_only, 1)
  expect_equal(out$n_vars_compare_only, 1)
  expect_equal(out$n_vars_common, 2)
})

test_that("compare_summary() counts value differences and class mismatches", {
  base <- data.frame(id = 1:2, val = c("a", "b"), stringsAsFactors = FALSE)
  compare <- data.frame(id = 1:2, val = c("a", "B"), stringsAsFactors = FALSE)
  out <- compare_summary(compare = compare, base = base, by = "id")
  expect_equal(out$n_value_diffs, 1)
  expect_equal(out$n_vars_with_diffs, 1)
})

test_that("print.dfdiffs_summary() prints without error", {
  out <- compare_summary(compare = Roster2022, base = Roster2021, by = "subject_id")
  expect_output(print(out), "dfdiffs comparison summary")
  expect_output(print(out), "No unequal values found")
})
