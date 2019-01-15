context("test-print")

test_that("print tbl_data", {
  unloadNamespace("tibble")
  d1 <- as_tbl_data(mtcars, row_names = TRUE)
  d2 <- d1
  names(d2) <- paste0("bignames_", names(d2))
  d2 <- repos_back(d2, bignames_row_names)
  expect_true(is.data.frame(d2))
  expect_equal("bignames_row_names", names(d2)[ncol(d2)])
  d1 <- repos_front(d1, mpg)
  expect_true(is.data.frame(d1))
  expect_equal(names(d1)[1], "mpg")
  ow <- getOption("width")
  options(width = 120)
  d <- bind_cols_data(d2, d1)
  o <- capture.output(print(d))
  expect_equal(length(o), 13)
  var_names <- strsplit(o[2], "\\s+")[[1]][-1]
  expect_equal(length(var_names), 8)
  expect_equal(
    c("bignames_mpg", "bignames_cyl", "bignames_disp\u2026", "bignames_hp"),
    var_names[1:4]
  )
  expect_equal(nrow(slice_data(d, 1:5)), 5)
  expect_error(slice_data(d, 1:5, 3))
  options(width = ow)
})
