context("test-tbl")

test_that("as_tbl, tabsort, ntbl", {
  d <- data.frame(abc = sample(letters[1:3], 100, replace = TRUE),
    xyz = sample(letters[24:26], 100, replace = TRUE),
    stringsAsFactors = FALSE)
  expect_true(inherits(as_tbl(d), "tbl_df"))
  d <- tabsort(d)
  expect_equal(ncol(d), 4)
  expect_true(inherits(d, "tbl_df"))
  expect_true(inherits(as_tbl(d), "tbl_df"))
  expect_true(is.data.frame((ntbl(d, n))))
  expect_equal(ncol(ntbl(d, n)), 2)
})

test_that("filter_rows, arrange_rows", {
  set.seed(12)
  d <- data.frame(abc = sample(letters[1:3], 100, replace = TRUE),
    xyz = sample(letters[24:26], 100, replace = TRUE),
    stringsAsFactors = FALSE)
  expect_true(is.data.frame(filter_rows(d, d$abc == "a")))
  expect_equal(nrow(filter_rows(d, d$abc == "a")), 34)
  expect_equal(ncol(filter_rows(d, d$abc == "a")), 2)
  d <- arrange_rows(d, abc, xyz)
  expect_true(is.data.frame(d))
  expect_true(max(which(d$abc == "c")) < min(which(d$abc == "a")))
  expect_true(
    min(which(d$abc == "c" & d$xyz == "x")) >
      max(which(d$abc == "c" & d$xyz == "z"))
  )
  expect_equal(nrow(d), 100)
})


test_that("do_call_rbind", {
  ## list of data frames with inconsistent columns
  x <- data.frame(
    a = letters,
    b = 1:26,
    c = rnorm(26),
    stringsAsFactors = FALSE
  )
  xx <- x
  xx$d <- "d"
  xxx <- x
  xxx$a <- factor(xxx$a)
  l <- list(x, xx, xxx)
  d <- do_call_rbind(l)
  expect_true(is.data.frame(d))
  expect_equal(nrow(d), 78)
  expect_equal(ncol(d), 4)
  expect_true(is.character(d$a))
  expect_true(is.character(d$d))
})


test_that("select_cols", {
  ## list of data frames with inconsistent columns
  x <- data.frame(
    a = letters,
    b = 1:26,
    c = rnorm(26),
    stringsAsFactors = FALSE
  )
  d <- select_cols(x, a, b)
  expect_true(is.data.frame(d))
  expect_equal(nrow(d), 26)
  expect_equal(ncol(d), 2)
  expect_true(is.character(d$a))
  expect_true(is.integer(d$b))
})

