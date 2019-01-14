
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

Install the development version from Github with:

``` r
## install remotes pkg if not already
if (!requireNamespace("remotes")) {
  install.packages("remotes")
}

## install from github
remotes::install_github("mkearney/tbltools")
```

## Use

  - **`as_tbl_data()`**: Convert data frames to tibbles

<!-- end list -->

``` r
## convert mtcars to tibble and create row_names variable
d <- as_tbl_data(mtcars, row_names = TRUE)
```

### Filter

  - **`filter_data()`**: Select which rows to return

<!-- end list -->

``` r
## count by cyl and gear
filter_data(d, gear > 3 | mpg > 30, vs == 1)
#> # A tibble: 11 x 12
#>    row_names   mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear
#>    <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#>  1 Datsun 7…  22.8     4 108      93  3.85  2.32  18.6     1     1     4
#>  2 Merc 240D  24.4     4 147.     62  3.69  3.19  20       1     0     4
#>  3 Merc 230   22.8     4 141.     95  3.92  3.15  22.9     1     0     4
#>  4 Merc 280   19.2     6 168.    123  3.92  3.44  18.3     1     0     4
#>  5 Merc 280C  17.8     6 168.    123  3.92  3.44  18.9     1     0     4
#>  6 Fiat 128   32.4     4  78.7    66  4.08  2.2   19.5     1     1     4
#>  7 Honda Ci…  30.4     4  75.7    52  4.93  1.62  18.5     1     1     4
#>  8 Toyota C…  33.9     4  71.1    65  4.22  1.84  19.9     1     1     4
#>  9 Fiat X1-9  27.3     4  79      66  4.08  1.94  18.9     1     1     4
#> 10 Lotus Eu…  30.4     4  95.1   113  3.77  1.51  16.9     1     1     5
#> # … with 1 more row, and 1 more variable: carb <dbl>
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
#> # A tibble: 32 x 12
#>    row_names   mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear
#>    <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#>  1 Ford Pan…  15.8     8 351     264  4.22  3.17  14.5     0     1     5
#>  2 Maserati…  15       8 301     335  3.54  3.57  14.6     0     1     5
#>  3 Ferrari …  19.7     6 145     175  3.62  2.77  15.5     0     1     5
#>  4 Porsche …  26       4 120.     91  4.43  2.14  16.7     0     1     5
#>  5 Lotus Eu…  30.4     4  95.1   113  3.77  1.51  16.9     1     1     5
#>  6 Mazda RX4  21       6 160     110  3.9   2.62  16.5     0     1     4
#>  7 Mazda RX…  21       6 160     110  3.9   2.88  17.0     0     1     4
#>  8 Merc 280   19.2     6 168.    123  3.92  3.44  18.3     1     0     4
#>  9 Merc 280C  17.8     6 168.    123  3.92  3.44  18.9     1     0     4
#> 10 Datsun 7…  22.8     4 108      93  3.85  2.32  18.6     1     1     4
#> # … with 22 more rows, and 1 more variable: carb <dbl>
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
#> # A tibble: 32 x 3
#>      cyl  gear weight
#>    <dbl> <dbl>  <dbl>
#>  1     6     4   2.62
#>  2     6     4   2.88
#>  3     4     4   2.32
#>  4     6     3   3.22
#>  5     8     3   3.44
#>  6     6     3   3.46
#>  7     8     3   3.57
#>  8     4     4   3.19
#>  9     4     4   3.15
#> 10     6     4   3.44
#> # … with 22 more rows
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
#> # A tibble: 32 x 4
#>      cyl  gear   mpg eff  
#>    <dbl> <dbl> <dbl> <lgl>
#>  1     6     4  21   TRUE 
#>  2     6     4  21   TRUE 
#>  3     4     4  22.8 TRUE 
#>  4     6     3  21.4 TRUE 
#>  5     8     3  18.7 FALSE
#>  6     6     3  18.1 FALSE
#>  7     8     3  14.3 FALSE
#>  8     4     4  24.4 TRUE 
#>  9     4     4  22.8 TRUE 
#> 10     6     4  19.2 FALSE
#> # … with 22 more rows
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
#> # A tibble: 1 x 2
#>     mpg    wt
#>   <dbl> <dbl>
#> 1  20.1  3.22
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
#> # A tibble: 3 x 3
#>       n   mpg   cyl
#>   <int> <dbl> <dbl>
#> 1     7  19.7     6
#> 2    11  26.7     4
#> 3    14  15.1     8
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
#> # A tibble: 96 x 13
#>    row_names   mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear
#>    <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#>  1 Mazda RX4  21       6  160    110  3.9   2.62  16.5     0     1     4
#>  2 Mazda RX…  21       6  160    110  3.9   2.88  17.0     0     1     4
#>  3 Datsun 7…  22.8     4  108     93  3.85  2.32  18.6     1     1     4
#>  4 Hornet 4…  21.4     6  258    110  3.08  3.22  19.4     1     0     3
#>  5 Hornet S…  18.7     8  360    175  3.15  3.44  17.0     0     0     3
#>  6 Valiant    18.1     6  225    105  2.76  3.46  20.2     1     0     3
#>  7 Duster 3…  14.3     8  360    245  3.21  3.57  15.8     0     0     3
#>  8 Merc 240D  24.4     4  147.    62  3.69  3.19  20       1     0     4
#>  9 Merc 230   22.8     4  141.    95  3.92  3.15  22.9     1     0     4
#> 10 Merc 280   19.2     6  168.   123  3.92  3.44  18.3     1     0     4
#> # … with 86 more rows, and 2 more variables: carb <dbl>, new_var <chr>
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
#> Joining, by = cyl
#> # A tibble: 1 x 12
#>     mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb   new
#>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1  24.4     4  147.    62  3.69  3.19    20     1     0     4     2   2.5
```

Compare with `dplyr::left_join()`:

``` r
same_as_dplyr(
  left_join_data(x, y),
  dplyr::left_join(x, y)
)
#> Joining, by = cyl
#> Joining, by = "cyl"
#> [1] FALSE
```

  - **`right_join_data()`**: Join according to second (right) data frame

<!-- end list -->

``` r
## join by y
right_join_data(x, y)
#> Joining, by = cyl
#> # A tibble: 12 x 12
#>      mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb   new
#>    <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#>  1  22.8     4 108      93  3.85  2.32  18.6     1     1     4     1   2.5
#>  2  24.4     4 147.     62  3.69  3.19  20       1     0     4     2   2.5
#>  3  22.8     4 141.     95  3.92  3.15  22.9     1     0     4     2   2.5
#>  4  32.4     4  78.7    66  4.08  2.2   19.5     1     1     4     1   2.5
#>  5  30.4     4  75.7    52  4.93  1.62  18.5     1     1     4     2   2.5
#>  6  33.9     4  71.1    65  4.22  1.84  19.9     1     1     4     1   2.5
#>  7  21.5     4 120.     97  3.7   2.46  20.0     1     0     3     1   2.5
#>  8  27.3     4  79      66  4.08  1.94  18.9     1     1     4     1   2.5
#>  9  26       4 120.     91  4.43  2.14  16.7     0     1     5     2   2.5
#> 10  30.4     4  95.1   113  3.77  1.51  16.9     1     1     5     2   2.5
#> # … with 2 more rows
```

Compare with `dplyr::left_join()`:

``` r
same_as_dplyr(
  right_join_data(x, y),
  dplyr::right_join(x, y)
)
#> Joining, by = cyl
#> Joining, by = "cyl"
#> [1] FALSE
```

  - **`full_join_data()`**: Join according to both data frames

<!-- end list -->

``` r
## join by x and y
full_join_data(x, y)
#> Joining, by = cyl
#> # A tibble: 33 x 12
#>      mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb   new
#>    <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#>  1  21       6  160    110  3.9   2.62  16.5     0     1     4     4  NA  
#>  2  21       6  160    110  3.9   2.88  17.0     0     1     4     4  NA  
#>  3  22.8     4  108     93  3.85  2.32  18.6     1     1     4     1   2.5
#>  4  21.4     6  258    110  3.08  3.22  19.4     1     0     3     1  NA  
#>  5  18.7     8  360    175  3.15  3.44  17.0     0     0     3     2  NA  
#>  6  18.1     6  225    105  2.76  3.46  20.2     1     0     3     1  NA  
#>  7  14.3     8  360    245  3.21  3.57  15.8     0     0     3     4  NA  
#>  8  24.4     4  147.    62  3.69  3.19  20       1     0     4     2   2.5
#>  9  22.8     4  141.    95  3.92  3.15  22.9     1     0     4     2   2.5
#> 10  19.2     6  168.   123  3.92  3.44  18.3     1     0     4     4  NA  
#> # … with 23 more rows
```

Compare with `dplyr::left_join()`:

``` r
same_as_dplyr(
  full_join_data(x, y),
  dplyr::full_join(x, y)
)
#> Joining, by = cyl
#> Joining, by = "cyl"
#> [1] TRUE
```

### Frequency tables

  - **`tabsort()`**: Count frequencies

<!-- end list -->

``` r
## count by cyl and gear
tabsort(d, cyl, gear)
#> # A tibble: 9 x 4
#>   cyl   gear      n   prop
#>   <chr> <chr> <int>  <dbl>
#> 1 8     3        12 0.375 
#> 2 4     4         8 0.25  
#> 3 6     4         4 0.125 
#> 4 6     3         2 0.0625
#> 5 4     5         2 0.0625
#> 6 8     5         2 0.0625
#> 7 4     3         1 0.0312
#> 8 6     5         1 0.0312
#> 9 8     4         0 0
```
