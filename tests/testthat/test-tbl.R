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
