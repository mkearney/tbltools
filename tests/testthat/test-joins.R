context("test-joins")

test_that("full_join, left_join, right_join", {
  ## mtcars data and additional cyl/new data
  x <- tbltools::as_tbl_data(mtcars)
  y <- data.frame(cyl = c(1, 4), new = c(1.25, 2.5))

  expect_message(o <- full_join_data(x, y))
  expect_true(is.data.frame(o))
  expect_equal(nrow(o), 33)
  expect_equal(ncol(o), 12)
  expect_true("new" %in% names(o))
  expect_equal(sum(is.na(o$new)), 21)

  expect_message(o <- left_join_data(x, y))
  expect_true(is.data.frame(o))
  expect_equal(nrow(o), 32)
  expect_equal(ncol(o), 12)
  expect_true("new" %in% names(o))
  expect_equal(sum(is.na(o$new)), 21)

  expect_message(o <- right_join_data(x, y))
  expect_true(is.data.frame(o))
  expect_equal(nrow(o), 12)
  expect_equal(ncol(o), 12)
  expect_true("new" %in% names(o))
  expect_equal(sum(is.na(o$new)), 0)
})
