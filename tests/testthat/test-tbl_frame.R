context("test-tbl_frame")

test_that("multiplication works", {
  set.seed(12)
  d <- tbl_data_frame(
    a = rnorm(10),
    b = rnorm(10)
  )
  expect_equal(ncol(d), 2)
  expect_true(!identical(d[[1]], d[[2]]))

  d <- tbl_data_frame(
    a = rnorm(10),
    b = rnorm(10),
    c = (a + b) / 2,
    d = a + b + c
  )
  expect_equal(ncol(d), 4)
  expect_true(identical(rowMeans(d[, 1:2]), d$c))
  expect_true(identical(round(rowSums(d[, 1:3]), 4), round(d$d, 4)))
})
