
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tbltools <img src="man/figures/logo.png" width="160px" align="right" />

[![Build
status](https://travis-ci.org/mkearney/tbltools.svg?branch=master)](https://travis-ci.org/mkearney/tbltools)
[![CRAN
status](https://www.r-pkg.org/badges/version/tbltools)](https://cran.r-project.org/package=tbltools)
[![Coverage
status](https://codecov.io/gh/mkearney/tbltools/branch/master/graph/badge.svg)](https://codecov.io/github/mkearney/tbltools?branch=master)

![Downloads](https://cranlogs.r-pkg.org/badges/tbltools)
![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/tbltools)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

Tools for Working with Tibbles

## Installation

Install from CRAN with:

``` r
## install {tbltools} from CRAN
install.packages("tbltools")
```

Or install the development version from Github with:

``` r
## install remotes pkg if not already
if (!requireNamespace("remotes")) {
  install.packages("remotes")
}

## install from github
remotes::install_github("mkearney/tbltools")
```

## Features

  - **Tidyverse-style** functionality\!
      - Uses **non-standard evaluation for easy interactive analysis**
      - Exports [{dplyr}](https://dplyr.tidyverse.org)-like
        **`_data()`** functions e.g., `arrange_data()` `filter_data()`,
        `select_data()`, `mutate_data()`, `summarise_data()`,
        `bind_rows_data()`, `bind_cols_data()`, `full_join_data()`,
        `left_join_data()`, `right_join_data()`
  - Simple and effective **printing of data frames**
      - Provides **[{tibble}](https://tibble.tidyverse.org)-like**
        printing experience
  - Extremely **lightweight**\!
      - Has **zero dependencies**-only requires base R
      - Compiles **quickly and easily**-ideal for new users,
        new/difficult machines, working remotely, etc.

## Use

  - **`as_tbl_data()`**: Convert data frames to tibbles

<!-- end list -->

``` r
## convert mtcars to tibble and create row_names variable
d <- as_tbl_data(mtcars, row_names = TRUE)
```

  - \*\*`tbl_dat_frame()`: Create data frames using previously defined
    variables

<!-- end list -->

``` r
## create data frame where 2 variable depends on evaluation of 1st variable
tbl_data_frame(
  x = rnorm(20),
  y = rnorm(20) + x
) %>%
  cor()
#>           x         y
#> x 1.0000000 0.6428509
#> y 0.6428509 1.0000000
```

### Slice

  - **`slice_data()`**: Select/keep/return row positions

<!-- end list -->

``` r
## select rows 1, 3, 5, 25 of data
slice_data(d, c(1, 3, 5, 25))
#> # A pseudo tibble: 4 x 12+
#>        row_names  mpg cyl disp  hp drat    wt  qsec vs am gear
#> 1)     Mazda RX4 21.0   6  160 110 3.90 2.620 16.46  0  1    4
#> 2)    Datsun 710 22.8   4  108  93 3.85 2.320 18.61  1  1    4
#> 3)  Hornet Spor… 18.7   8  360 175 3.15 3.440 17.02  0  0    3
#> 4)  Pontiac Fir… 19.2   8  400 175 3.08 3.845 17.05  0  0    3
#> +1 columns not printed
```

Compare with `dplyr::filter()`

``` r
same_as_dplyr(
  slice_data(d, c(1, 3, 5, 25)),
  dplyr::slice(d, c(1, 3, 5, 25))
)
#> [1] FALSE
```

### Filter

  - **`filter_data()`**: Filter/keep/return certain rows

<!-- end list -->

``` r
## count by cyl and gear
filter_data(d, gear > 3 | mpg > 30, vs == 1)
#> # A pseudo tibble: 11* x 12+
#>      row_names  mpg cyl  disp  hp drat   wt  qsec vs am gear
#> 1)  Datsun 710 22.8   4 108.0  93 3.85 2.32 18.61  1  1    4
#> 2)   Merc 240D 24.4   4 146.7  62 3.69 3.19 20.00  1  0    4
#> 3)    Merc 230 22.8   4 140.8  95 3.92 3.15 22.90  1  0    4
#> 4)    Merc 280 19.2   6 167.6 123 3.92 3.44 18.30  1  0    4
#> *7 rows not printed;  +1 columns not printed
```

Compare with `dplyr::filter()`

``` r
same_as_dplyr(
  filter_data(d, gear > 3 | mpg > 30, vs == 1),
  dplyr::filter(d, gear > 3 | mpg > 30, vs == 1)
)
#> [1] TRUE
```

### Arrange

  - **`arrange_data()`**: Organize rows by column(s) value

<!-- end list -->

``` r
## count by cyl and gear
arrange_data(d, gear, cyl)
#> # A pseudo tibble: 32* x 12+
#>        row_names  mpg cyl  disp  hp drat   wt qsec vs am gear
#> 1)  Ford Panter… 15.8   8 351.0 264 4.22 3.17 14.5  0  1    5
#> 2)  Maserati Bo… 15.0   8 301.0 335 3.54 3.57 14.6  0  1    5
#> 3)  Ferrari Din… 19.7   6 145.0 175 3.62 2.77 15.5  0  1    5
#> 4)  Porsche 914… 26.0   4 120.3  91 4.43 2.14 16.7  0  1    5
#> *28 rows not printed;  +1 columns not printed
```

Compare with `dplyr::arrange()`

``` r
same_as_dplyr(
  arrange_data(d, gear, cyl, desc = FALSE),
  dplyr::arrange(d, gear, cyl)
)
#> [1] TRUE
```

### Select

  - **`select_data()`**: Select columns of data frame

<!-- end list -->

``` r
## select only these columns
select_data(d, cyl, gear, weight = wt)
#> # A pseudo tibble: 32* x 3
#>     cyl gear weight
#> 1)    6    4  2.620
#> 2)    6    4  2.875
#> 3)    4    4  2.320
#> 4)    6    3  3.215
#> *28 rows not printed
```

Compare with `dplyr::select()`

``` r
same_as_dplyr(
  select_data(d, cyl, gear, weight = wt),
  dplyr::select(d, cyl, gear, weight = wt)
)
#> [1] TRUE
```

### Mutate

  - **`mutate_data()`**: Wrangle/create variables in data
frame

<!-- end list -->

``` r
## select cyl, gear, mpg columns and create new logical column for more efficient cars
d %>%
  select_data(cyl, gear, mpg) %>%
  mutate_data(eff = mpg > 20)
#> # A pseudo tibble: 32* x 4
#>     cyl gear  mpg  eff
#> 1)    6    4 21.0 TRUE
#> 2)    6    4 21.0 TRUE
#> 3)    4    4 22.8 TRUE
#> 4)    6    3 21.4 TRUE
#> *28 rows not printed
```

Compare with `dplyr::mutate()`

``` r
same_as_dplyr(
  d %>%
    select_data(cyl, gear, mpg) %>%
    mutate_data(eff = mpg > 20),
  d %>%
    dplyr::select(cyl, gear, mpg) %>%
    dplyr::mutate(eff = mpg > 20)
)
#> [1] TRUE
```

### Summarise

  - **`summarise_data()`**: Wrangle/create summary variables in data
    frame

<!-- end list -->

``` r
## select cyl, gear, mpg columns and create new logical column for more efficient cars
summarise_data(d, mpg = mean(mpg), wt = mean(wt))
#> # A pseudo tibble: 1 x 2
#>          mpg      wt
#> 1)  20.09062 3.21725
```

Compare with `dplyr::summarise()`

``` r
same_as_dplyr(
  summarise_data(d, mpg = mean(mpg), wt = mean(wt)),
  dplyr::summarise(d, mpg = mean(mpg), wt = mean(wt))
)
#> [1] TRUE
```

### Group by

  - **`group_by_data()`**: Group observations in data frame \[and then
    mutate and/or summarise\]

<!-- end list -->

``` r
## group by cyl
d %>%
  select_data(cyl, gear, mpg) %>%
  group_by_data(cyl) %>%
  mutate_data(n = length(gear)) %>%
  summarise_data(
    n = unique(n),
    mpg = mean(mpg)
  )
#> # A pseudo tibble: 3 x 3
#>      n      mpg cyl
#> 1)   7 19.74286   6
#> 2)  11 26.66364   4
#> 3)  14 15.10000   8
```

Compare with `dplyr::group_by()`

``` r
same_as_dplyr(
  d %>%
    select_data(cyl, gear, mpg) %>%
    group_by_data(cyl) %>%
    mutate_data(n = length(gear)) %>%
    summarise_data(
      n = unique(n),
      mpg_total = sum(mpg),
      mpg = mean(mpg)
    ) %>%
    arrange_data(cyl, desc = FALSE) %>%
    select_data(cyl, mpg_total, mpg, n),
  d %>%
    dplyr::select(cyl, gear, mpg) %>%
    dplyr::group_by(cyl) %>%
    dplyr::mutate(n = length(gear)) %>%
    dplyr::summarise(
      n = unique(n),
      mpg_total = sum(mpg),
      mpg = mean(mpg)
    ) %>%
    dplyr::arrange(cyl) %>%
    dplyr::select(cyl, mpg_total, mpg, n)
)
#> [1] TRUE
```

### Bind rows

  - **`bind_rows_data()`**: Collapse list of data frames into single
    data frame

<!-- end list -->

``` r
## create version of data with new variable
dd <- d
dd$new_var <- sample(letters, nrow(d), replace = TRUE)

## combine multiple data sets into list
lst <- list(d, d, dd)

## bind rows into single data frame
bind_rows_data(lst)
#> # A pseudo tibble: 96* x 13+
#>        row_names  mpg cyl disp  hp drat    wt  qsec vs am gear
#> 1)     Mazda RX4 21.0   6  160 110 3.90 2.620 16.46  0  1    4
#> 2)  Mazda RX4 W… 21.0   6  160 110 3.90 2.875 17.02  0  1    4
#> 3)    Datsun 710 22.8   4  108  93 3.85 2.320 18.61  1  1    4
#> 4)  Hornet 4 Dr… 21.4   6  258 110 3.08 3.215 19.44  1  0    3
#> *92 rows not printed;  +2 columns not printed
```

Compare to `dplyr::bind_rows()`

``` r
same_as_dplyr(
  bind_rows_data(lst),
  dplyr::bind_rows(lst)
)
#> [1] TRUE
```

### Joins

  - Data to compare with [dplyr](https://github.com/tidyverse/dplyr)
    joins:

<!-- end list -->

``` r
## mtcars data and additional cyl/new data
x <- tbltools::as_tbl_data(mtcars)
y <- data.frame(cyl = c(1, 4), new = c(1.25, 2.5))
```

  - **`left_join_data()`**: Join according to first (left) data frame

<!-- end list -->

``` r
## join according to x
left_join_data(x, y)
#> Joining, by = "cyl"
#> # A pseudo tibble: 32* x 12
#>      mpg cyl disp  hp drat    wt  qsec vs am gear carb new
#> 1)  21.0   6  160 110 3.90 2.620 16.46  0  1    4    4  NA
#> 2)  21.0   6  160 110 3.90 2.875 17.02  0  1    4    4  NA
#> 3)  22.8   4  108  93 3.85 2.320 18.61  1  1    4    1 2.5
#> 4)  21.4   6  258 110 3.08 3.215 19.44  1  0    3    1  NA
#> *28 rows not printed
```

Compare with `dplyr::left_join()`:

``` r
same_as_dplyr(
  left_join_data(x, y),
  dplyr::left_join(x, y)
)
#> Joining, by = "cyl"
#> Joining, by = "cyl"
#> [1] TRUE
```

  - **`right_join_data()`**: Join according to second (right) data frame

<!-- end list -->

``` r
## join by y
right_join_data(x, y)
#> Joining, by = "cyl"
#> # A pseudo tibble: 12* x 12
#>      mpg cyl  disp hp drat   wt  qsec vs am gear carb  new
#> 1)    NA   1    NA NA   NA   NA    NA NA NA   NA   NA 1.25
#> 2)  22.8   4 108.0 93 3.85 2.32 18.61  1  1    4    1 2.50
#> 3)  24.4   4 146.7 62 3.69 3.19 20.00  1  0    4    2 2.50
#> 4)  22.8   4 140.8 95 3.92 3.15 22.90  1  0    4    2 2.50
#> *8 rows not printed
```

Compare with `dplyr::left_join()`:

``` r
same_as_dplyr(
  right_join_data(x, y),
  dplyr::right_join(x, y)
)
#> Joining, by = "cyl"
#> Joining, by = "cyl"
#> [1] TRUE
```

  - **`full_join_data()`**: Join according to both data frames

<!-- end list -->

``` r
## join by x and y
full_join_data(x, y)
#> Joining, by = "cyl"
#> # A pseudo tibble: 33* x 12
#>      mpg cyl disp  hp drat    wt  qsec vs am gear carb new
#> 1)  21.0   6  160 110 3.90 2.620 16.46  0  1    4    4  NA
#> 2)  21.0   6  160 110 3.90 2.875 17.02  0  1    4    4  NA
#> 3)  22.8   4  108  93 3.85 2.320 18.61  1  1    4    1 2.5
#> 4)  21.4   6  258 110 3.08 3.215 19.44  1  0    3    1  NA
#> *29 rows not printed
```

Compare with `dplyr::left_join()`:

``` r
same_as_dplyr(
  full_join_data(x, y),
  dplyr::full_join(x, y)
)
#> Joining, by = "cyl"
#> Joining, by = "cyl"
#> [1] TRUE
```

### Frequency tables

  - **`tabsort()`**: Count frequencies

<!-- end list -->

``` r
## count by cyl and gear
tabsort(d, cyl, gear)
#> # A pseudo tibble: 9* x 4
#>     cyl gear  n   prop
#> 1)    8    3 12 0.3750
#> 2)    4    4  8 0.2500
#> 3)    6    4  4 0.1250
#> 4)    6    3  2 0.0625
#> *5 rows not printed
```
