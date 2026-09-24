test_that("select_cols() subsets columns by name, in the order given", {
  df <- data.frame(a = 1:2, b = 3:4, c = 5:6)
  out <- select_cols(df, c("c", "a"))
  expect_equal(names(out), c("c", "a"))
  expect_equal(out$a, 1:2)
})

test_that("select_cols() errors clearly on a missing column", {
  df <- data.frame(a = 1:2, b = 3:4)
  expect_error(select_cols(df, c("a", "nope")), "nope")
})

test_that("anti_join_base() keeps only unmatched rows of x, x's columns only", {
  x <- data.frame(id = c(1, 2, 3), val = c("a", "b", "c"))
  y <- data.frame(id = c(2, 3), other = c("y", "z"))
  out <- anti_join_base(x, y, by = "id")
  expect_equal(out$id, 1)
  expect_equal(names(out), c("id", "val"))
})

test_that("anti_join_base() matches on multi-column keys", {
  x <- data.frame(a = c(1, 1, 2), b = c("x", "y", "x"), val = 1:3)
  y <- data.frame(a = c(1), b = c("x"))
  out <- anti_join_base(x, y, by = c("a", "b"))
  expect_equal(nrow(out), 2)
  expect_true(all(!(out$a == 1 & out$b == "x")))
})

test_that("anti_join_base() treats NA-in-key as matching NA-in-key (dplyr semantics)", {
  x <- data.frame(id = c(1, NA, 3), val = 1:3)
  y <- data.frame(id = c(NA))
  out <- anti_join_base(x, y, by = "id")
  expect_equal(out$id, c(1, 3))
})

test_that("left_join_base() attaches y's columns to matching x rows", {
  x <- data.frame(id = c(1, 2), val = c("a", "b"))
  y <- data.frame(id = c(1, 2), extra = c("p", "q"))
  out <- left_join_base(x, y, by = "id")
  expect_true(all(c("id", "val", "extra") %in% names(out)))
  expect_equal(out$extra[out$id == 1], "p")
})

test_that("left_join_base() keeps unmatched x rows with NA for y's columns", {
  x <- data.frame(id = c(1, 2), val = c("a", "b"))
  y <- data.frame(id = c(1), extra = c("p"))
  out <- left_join_base(x, y, by = "id")
  expect_equal(nrow(out), 2)
  expect_true(is.na(out$extra[out$id == 2]))
})
