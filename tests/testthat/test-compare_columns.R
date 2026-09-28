test_that("compare_columns() reports base-only, compare-only, and common columns", {
  base <- data.frame(a = 1:2, b = 3:4, only_base = 5:6)
  compare <- data.frame(a = 1:2, b = 3:4, only_compare = 7:8)
  out <- compare_columns(base, compare)
  expect_s3_class(out, "dfdiffs_column_diff")
  expect_equal(out$base_only, "only_base")
  expect_equal(out$compare_only, "only_compare")
  expect_equal(out$common, c("a", "b"))
})

test_that("compare_columns() returns empty character vectors when columns match exactly", {
  base <- data.frame(a = 1:2, b = 3:4)
  compare <- data.frame(a = 5:6, b = 7:8)
  out <- compare_columns(base, compare)
  expect_equal(out$base_only, character(0))
  expect_equal(out$compare_only, character(0))
  expect_equal(out$common, c("a", "b"))
})

test_that("print.dfdiffs_column_diff() prints without error", {
  base <- data.frame(a = 1:2, only_base = 3:4)
  compare <- data.frame(a = 1:2, only_compare = 5:6)
  out <- compare_columns(base, compare)
  expect_output(print(out), "dfdiffs column diff")
  expect_output(print(out), "only_base")
  expect_output(print(out), "only_compare")
})
