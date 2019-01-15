context("test-print")

test_that("print tbl_data", {
  unloadNamespace("tibble")
  d1 <- as_tbl_data(mtcars, row_names = TRUE)
  d2 <- d1
  names(d2) <- paste0("bignames_", names(d2))
  d2 <- repos_back(d2, bignames_row_names)
  ow <- getOption("width")
  options(width = 120)
  d <- bind_cols_data(d2, d1)
  o <- capture.output(print(d))
  expect_equal(length(o), 12)
  var_names <- strsplit(o[2], "\\s+")[[1]][-1]
  expect_equal(length(var_names), 9)
  expect_equal(
    c("bignames_mpg", "bignames_cyl", "bignames_disp", "bignames_hp"),
    var_names[1:4]
  )
  options(width = ow)
})
