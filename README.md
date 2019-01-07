
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

  - **`as_tbl()`**: Convert data frames to tibbles

<!-- end list -->

``` r
## convert mtcars to tibble and create row_names variable
d <- as_tbl(mtcars, row_names = TRUE)
```

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

  - **`filter_rows()`**: Select which rows to return

<!-- end list -->

``` r
## count by cyl and gear
filter_rows(d, d$gear == 5)
#> # A tibble: 5 x 12
#>   row_names   mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear
#>   <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 Porsche …  26       4 120.     91  4.43  2.14  16.7     0     1     5
#> 2 Lotus Eu…  30.4     4  95.1   113  3.77  1.51  16.9     1     1     5
#> 3 Ford Pan…  15.8     8 351     264  4.22  3.17  14.5     0     1     5
#> 4 Ferrari …  19.7     6 145     175  3.62  2.77  15.5     0     1     5
#> 5 Maserati…  15       8 301     335  3.54  3.57  14.6     0     1     5
#> # ... with 1 more variable: carb <dbl>
```

  - **`arrange_rows()`**: Organize rows by column(s) value

<!-- end list -->

``` r
## count by cyl and gear
arrange_rows(d, gear, cyl)
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
#> # ... with 22 more rows, and 1 more variable: carb <dbl>
```
