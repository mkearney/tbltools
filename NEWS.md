# tbltools 0.0.5

* tbltools is a lot lighter as rlang, tibble, and tidyselect are no longer dependencies

# tbltools 0.0.4

* Added `do_call_rbind()` as convenient shortcut for base do.call("rbind", ...) that will also fill in missing columns with missing values of appropriate class
* Added non-standard evaluation functionality to `filter_rows()`

# tbltools 0.0.3

* Added `filter_rows()` and `arrange_rows()` methods as convenient shortcuts

# tbltools 0.0.2

* Added a `NEWS.md` file to track changes to the package.
