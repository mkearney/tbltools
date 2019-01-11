context("test-group")

test_that("group_data", {
  d <- data.frame(
    mpg = c(10.5, 18.5, 22.5, 25.5),
    cyl = c(  8L,   6L,   4L,   4L),
    gear = c( 5L,   4L,   4L,   3L)
  )
  o <- d %>%
    filter_data(mpg > 11) %>%
    group_data(cyl) %>%
    mutate_data(n = length(gear)) %>%
    summarise_data(
        n = unique(n),
        mpg = mean(mpg)
      ) %>%
    arrange_data(mpg) %>%
    select_data(cyl, mpg, n)
  expect_true(is.data.frame(o))
  expect_equal(nrow(o), 2)
  expect_equal(ncol(o), 3)
  expect_equal(o$mpg, c(24, 18.5))
})
