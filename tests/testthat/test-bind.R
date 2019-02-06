context("test-bind")


test_that("bind_rows works", {
  d1 <- as_tbl_data(mtcars, row_names = TRUE)
  d2 <- d1
  ## each entered
  expect_true(is.data.frame(bind_rows_data(d1, d2, fill = TRUE)))
  expect_equal(nrow(bind_rows_data(d1, d2, fill = TRUE)), 64)
  ## as list
  expect_true(is.data.frame(bind_rows_data(list(d1, d2), fill = TRUE)))
  expect_equal(nrow(bind_rows_data(list(d1, d2), fill = TRUE)), 64)
})

test_that("bind_cols works", {
  d1 <- as_tbl_data(mtcars, row_names = TRUE)
  d2 <- d1
  names(d2) <- paste0("bignames_", names(d2))
  ## each entered
  expect_true(is.data.frame(bind_cols_data(d1, d2)))
  expect_equal(ncol(bind_rows_data(d1, d2, fill = TRUE)), 24)
  ## as list
  expect_true(is.data.frame(bind_cols_data(list(d1, d2))))
  expect_equal(ncol(bind_rows_data(list(d1, d2), fill = TRUE)), 24)
})



test_that("bind_rows_data", {
  ## list of data frames with inconsistent columns
  x <- tbl_data(
    a = letters,
    b = 1:26,
    c = rnorm(26)
  )
  xx <- x
  xx$d <- "d"
  xxx <- x
  xxx$a <- factor(xxx$a)
  l <- list(x, xx, xxx)
  d <- bind_rows_data(l, fill = TRUE)
  expect_true(is.data.frame(d))
  expect_equal(nrow(d), 78)
  expect_equal(ncol(d), 4)
  expect_true(is.character(d$a))
  expect_true(is.character(d$d))
})

