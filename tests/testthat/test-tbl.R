context("test-tbl")

test_that("as_tbl_data, tabsort, ntbl", {
  env <- environment()
  e <- data.frame(
    a = letters,
    b = LETTERS,
    c = seq_along(letters),
    d = data.frame(aa = letters, bb = LETTERS, cc = seq_along(letters)),
    row.names = rev(letters)
  )
  d <- data.frame(abc = sample(letters[1:3], 100, replace = TRUE),
    xyz = sample(letters[24:26], 100, replace = TRUE),
    stringsAsFactors = FALSE)
  env_tbls(env)
  expect_true(inherits(d, "tbl_df"))
  expect_true(inherits(e, "tbl_df"))
  e <- data.frame(
    a = letters,
    b = LETTERS,
    c = seq_along(letters),
    d = data.frame(aa = letters, bb = LETTERS, cc = seq_along(letters)),
    row.names = rev(letters)
  )
  d <- data.frame(abc = sample(letters[1:3], 100, replace = TRUE),
    xyz = sample(letters[24:26], 100, replace = TRUE),
    stringsAsFactors = FALSE)
  e <- as_tbl_data(e, row_names = TRUE)
  expect_named(e)
  expect_true("d.bb" %in% names(e))
  expect_equal(ncol(e), 7)
  expect_equal(nrow(e), 26)
  expect_true(is.factor(e$d.aa))
  expect_true(is.data.frame(e))
  expect_true(is.character(e$row_names))

  expect_true(inherits(as_tbl_data(d), "tbl_df"))
  d <- tabsort(d)
  expect_equal(ncol(d), 4)
  expect_true(inherits(d, "tbl_df"))
  expect_true(inherits(as_tbl_data(d), "tbl_df"))
  expect_true(is.data.frame((ntbl(d, n))))
  expect_equal(ncol(ntbl(d, n)), 2)

  expect_true(is.data.frame(
    expect_warning(
      tabsort(.data = sample(c("a", "b", "c"), nrow(e), replace = TRUE),
        n = sample(c("a", "b", "c"), nrow(e), replace = TRUE))
    )
  ))
  expect_error(tabsort(prop = 'a'))
})

test_that("filter_data, arrange_data", {
  set.seed(12)
  d <- data.frame(abc = sample(letters[1:3], 100, replace = TRUE),
    xyz = sample(letters[24:26], 100, replace = TRUE),
    stringsAsFactors = FALSE)
  expect_true(is.data.frame(filter_data(d, d$abc == "a")))
  expect_equal(nrow(filter_data(d, d$abc == "a")), 34)
  expect_equal(ncol(filter_data(d, d$abc == "a")), 2)
  d <- arrange_data(d, decr(abc), decr(xyz))
  expect_true(is.data.frame(d))
  expect_true(max(which(d$abc == "c")) < min(which(d$abc == "a")))
  expect_true(
    min(which(d$abc == "c" & d$xyz == "x")) >
      max(which(d$abc == "c" & d$xyz == "z"))
  )
  expect_equal(nrow(d), 100)
})



