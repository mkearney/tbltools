context("test-mutate")

test_that("mutate_if_data works", {
  x <- as_tbl_data(mtcars, row_names = TRUE) %>%
    group_by_data(cyl) %>%
    mutate_if_data(~ is.numeric(.x), ~ .x / mean(.x))
  expect_equal(nrow(x), 32)
  expect_equal(ncol(x), 12)
  x <- as_tbl_data(mtcars, row_names = TRUE) %>%
    group_by_data(cyl) %>%
    mutate_if_data(is.numeric, ~ mean(.x))
  expect_equal(length(unique(x$wt)), 3)
  x <- as_tbl_data(mtcars, row_names = TRUE) %>%
    mutate_if_data(~ is.numeric(.x), ~ .x / mean(.x)) %>%
    mutate_if_data(is.numeric, min)
  expect_equal(nrow(x), 32)
  expect_equal(ncol(x), 12)
  x <- as_tbl_data(mtcars, row_names = TRUE) %>%
    mutate_if_data(~ is.numeric(.x), min)
  expect_equal(nrow(x), 32)
  expect_equal(ncol(x), 12)
  expect_equal(n_uq(x$wt), 1)
})
