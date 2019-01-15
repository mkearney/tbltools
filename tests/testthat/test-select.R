context("test-select")

test_that("select_data", {
  ## list of data frames with inconsistent columns
  x <- data.frame(
    a = letters,
    b = 1:26,
    c = rnorm(26),
    d = 0,
    e = TRUE,
    f = sample(c(TRUE, FALSE), 26, replace = TRUE),
    g = sample(LETTERS),
    stringsAsFactors = FALSE
  )
  d <- select_data(x, a, b)
  expect_true(is.data.frame(d))
  expect_equal(nrow(d), 26)
  expect_equal(ncol(d), 2)
  expect_true(is.character(d$a))
  expect_true(is.integer(d$b))

  d <- select_data(x, -c)
  expect_true(is.data.frame(d))
  expect_equal(nrow(d), 26)
  expect_equal(ncol(d), 6)
  expect_true(is.character(d$a))
  expect_true(is.integer(d$b))

  d <- select_data(x, b:f, -d)
  expect_true(is.data.frame(d))
  expect_equal(nrow(d), 26)
  expect_equal(ncol(d), 4)
  expect_true(is.numeric(d$c))
  expect_true(!"d" %in% names(d))
  expect_true(is.integer(d$b))
  expect_true(is.logical(d$f))
  expect_true(is.logical(d$e))
})
