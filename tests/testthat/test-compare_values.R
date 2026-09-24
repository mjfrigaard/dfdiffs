test_that("compare_values() treats NA vs NA as not different", {
  expect_false(compare_values(NA_character_, NA_character_))
  expect_false(compare_values(NA_real_, NA_real_))
})

test_that("compare_values() treats NA vs a value as different", {
  expect_true(compare_values(NA_character_, "x"))
  expect_true(compare_values("x", NA_character_))
})

test_that("compare_values() does exact string comparison by default", {
  expect_true(compare_values("a", "b"))
  expect_false(compare_values("a", "a"))
})

test_that("compare_values() treats small numeric differences as equal within tolerance", {
  expect_false(compare_values(5.0, 5.0 + 1e-10))
  expect_true(compare_values(5.0, 5.1))
})

test_that("compare_values() respects a custom tolerance/scale", {
  expect_false(compare_values(5, 5.1, tolerance = 0.2))
  expect_true(compare_values(5, 5.1, tolerance = 0.01))
  expect_false(compare_values(5, 6, scale = 10, tolerance = 0.2))
})

test_that("compare_values() compares integer vs double numerics without flagging type alone", {
  expect_false(compare_values(5L, 5.0))
})

test_that("compare_values() treats a Date and a same-instant POSIXct as equal", {
  d <- as.Date("2024-01-15")
  pt <- as.POSIXct("2024-01-15 00:00:00", tz = "UTC")
  expect_false(compare_values(d, pt))
})

test_that("compare_values() flags a genuinely different Date/POSIXct pair", {
  d <- as.Date("2024-01-15")
  pt <- as.POSIXct("2024-01-16 00:00:00", tz = "UTC")
  expect_true(compare_values(d, pt))
})

test_that("compare_values() treats factor and character with the same label as equal by default", {
  expect_false(compare_values(factor("headache"), "headache"))
})

test_that("compare_values() with strict_factor = TRUE compares factor codes, not labels", {
  base_val <- factor("b", levels = c("a", "b"))
  compare_val <- "b"
  expect_true(compare_values(base_val, compare_val, strict_factor = TRUE))
})

test_that("compare_values() is vectorized", {
  out <- compare_values(c(1, 2, NA, 4), c(1, 3, NA, NA))
  expect_equal(out, c(FALSE, TRUE, FALSE, TRUE))
})

test_that("diff_values_by_key() matches rows on 'by' and reports differing values", {
  base <- data.frame(id = c(1, 2, 3), val = c("a", "b", "c"), stringsAsFactors = FALSE)
  compare <- data.frame(id = c(1, 2, 3), val = c("a", "B", "c"), stringsAsFactors = FALSE)
  out <- diff_values_by_key(base, compare, by = "id")

  expect_named(out, c("diffs", "diffs_byvar", "class_diffs"))
  expect_equal(nrow(out$diffs), 1)
  expect_equal(out$diffs$`Previous Value`, "b")
  expect_equal(out$diffs$`Current Value`, "B")
  expect_equal(out$diffs_byvar$`Modified Values`[out$diffs_byvar$`Variable name` == "val"], 1)
})

test_that("diff_values_by_key() reports zero diffs when values match", {
  base <- data.frame(id = c(1, 2), val = c("a", "b"), stringsAsFactors = FALSE)
  compare <- data.frame(id = c(1, 2), val = c("a", "b"), stringsAsFactors = FALSE)
  out <- diff_values_by_key(base, compare, by = "id")
  expect_equal(nrow(out$diffs), 0)
  expect_true(all(out$diffs_byvar$`Modified Values` == 0))
})

test_that("diff_values_by_key() records a genuine class mismatch", {
  base <- data.frame(id = 1, x = 1, stringsAsFactors = FALSE)
  compare <- data.frame(id = 1, stringsAsFactors = FALSE)
  compare$x <- I(list(1))
  out <- diff_values_by_key(base, compare, by = "id")
  expect_equal(nrow(out$class_diffs), 1)
  expect_equal(out$class_diffs$variable, "x")
})
