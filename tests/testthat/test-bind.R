context("test-bind")


test_that("bind_rows works", {
  d1 <- as_tbl_data(mtcars, row_names = TRUE)
  d2 <- d1
  ## each entered
  expect_true(is.data.frame(bind_rows_data(d1, d2)))
  expect_equal(nrow(bind_rows_data(d1, d2)), 64)
  ## as list
  expect_true(is.data.frame(bind_rows_data(list(d1, d2))))
  expect_equal(nrow(bind_rows_data(list(d1, d2))), 64)
})

test_that("bind_cols works", {
  d1 <- as_tbl_data(mtcars, row_names = TRUE)
  d2 <- d1
  names(d2) <- paste0("bignames_", names(d2))
  ## each entered
  expect_true(is.data.frame(bind_cols_data(d1, d2)))
  expect_equal(ncol(bind_rows_data(d1, d2)), 24)
  ## as list
  expect_true(is.data.frame(bind_cols_data(list(d1, d2))))
  expect_equal(ncol(bind_rows_data(list(d1, d2))), 24)
})
