
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
#>   cyl gear  n    prop
#> 3   8    3 12 0.37500
#> 4   4    4  8 0.25000
#> 5   6    4  4 0.12500
#> 2   6    3  2 0.06250
#> 7   4    5  2 0.06250
#> 9   8    5  2 0.06250
#> 1   4    3  1 0.03125
#> 8   6    5  1 0.03125
#> 6   8    4  0 0.00000
```

  - **`filter_rows()`**: Select which rows to return

<!-- end list -->

``` r
## count by cyl and gear
filter_rows(d, gear > 3 | mpg > 30, vs == 1)
#>         row_names  mpg cyl  disp  hp drat    wt  qsec vs am gear carb
#> 1      Datsun 710 22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
#> 2       Merc 240D 24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
#> 3        Merc 230 22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
#> 4        Merc 280 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
#> 5       Merc 280C 17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
#> 6        Fiat 128 32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
#> 7     Honda Civic 30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
#> 8  Toyota Corolla 33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
#> 9       Fiat X1-9 27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
#> 10   Lotus Europa 30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
#> 11     Volvo 142E 21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2
```

  - **`arrange_rows()`**: Organize rows by column(s) value

<!-- end list -->

``` r
## count by cyl and gear
arrange_rows(d, gear, cyl)
#>              row_names  mpg cyl  disp  hp drat    wt  qsec vs am gear carb
#> 1       Ford Pantera L 15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
#> 2        Maserati Bora 15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8
#> 3         Ferrari Dino 19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
#> 4        Porsche 914-2 26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
#> 5         Lotus Europa 30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
#> 6            Mazda RX4 21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
#> 7        Mazda RX4 Wag 21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
#> 8             Merc 280 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
#> 9            Merc 280C 17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
#> 10          Datsun 710 22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
#> 11           Merc 240D 24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
#> 12            Merc 230 22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
#> 13            Fiat 128 32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
#> 14         Honda Civic 30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
#> 15      Toyota Corolla 33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
#> 16           Fiat X1-9 27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
#> 17          Volvo 142E 21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2
#> 18   Hornet Sportabout 18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
#> 19          Duster 360 14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
#> 20          Merc 450SE 16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
#> 21          Merc 450SL 17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
#> 22         Merc 450SLC 15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
#> 23  Cadillac Fleetwood 10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
#> 24 Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
#> 25   Chrysler Imperial 14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
#> 26    Dodge Challenger 15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2
#> 27         AMC Javelin 15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2
#> 28          Camaro Z28 13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
#> 29    Pontiac Firebird 19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2
#> 30      Hornet 4 Drive 21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
#> 31             Valiant 18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
#> 32       Toyota Corona 21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
```

  - **`do_call_rbind()`**: Collapse list of data frames into single data
    frame

<!-- end list -->

``` r
## create version of data with new variable
dd <- d
dd$new_var <- sample(letters, nrow(d), replace = TRUE)

## combine multiple data sets into list
lst <- list(d, d, dd)

## bind rows into single data frame
do_call_rbind(lst)
#>              row_names  mpg cyl  disp  hp drat    wt  qsec vs am gear carb
#> 1            Mazda RX4 21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
#> 2        Mazda RX4 Wag 21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
#> 3           Datsun 710 22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
#> 4       Hornet 4 Drive 21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
#> 5    Hornet Sportabout 18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
#> 6              Valiant 18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
#> 7           Duster 360 14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
#> 8            Merc 240D 24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
#> 9             Merc 230 22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
#> 10            Merc 280 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
#> 11           Merc 280C 17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
#> 12          Merc 450SE 16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
#> 13          Merc 450SL 17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
#> 14         Merc 450SLC 15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
#> 15  Cadillac Fleetwood 10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
#> 16 Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
#> 17   Chrysler Imperial 14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
#> 18            Fiat 128 32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
#> 19         Honda Civic 30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
#> 20      Toyota Corolla 33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
#> 21       Toyota Corona 21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
#> 22    Dodge Challenger 15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2
#> 23         AMC Javelin 15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2
#> 24          Camaro Z28 13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
#> 25    Pontiac Firebird 19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2
#> 26           Fiat X1-9 27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
#> 27       Porsche 914-2 26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
#> 28        Lotus Europa 30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
#> 29      Ford Pantera L 15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
#> 30        Ferrari Dino 19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
#> 31       Maserati Bora 15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8
#> 32          Volvo 142E 21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2
#> 33           Mazda RX4 21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
#> 34       Mazda RX4 Wag 21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
#> 35          Datsun 710 22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
#> 36      Hornet 4 Drive 21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
#> 37   Hornet Sportabout 18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
#> 38             Valiant 18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
#> 39          Duster 360 14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
#> 40           Merc 240D 24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
#> 41            Merc 230 22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
#> 42            Merc 280 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
#> 43           Merc 280C 17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
#> 44          Merc 450SE 16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
#> 45          Merc 450SL 17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
#> 46         Merc 450SLC 15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
#> 47  Cadillac Fleetwood 10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
#> 48 Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
#> 49   Chrysler Imperial 14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
#> 50            Fiat 128 32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
#> 51         Honda Civic 30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
#> 52      Toyota Corolla 33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
#> 53       Toyota Corona 21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
#> 54    Dodge Challenger 15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2
#> 55         AMC Javelin 15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2
#> 56          Camaro Z28 13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
#> 57    Pontiac Firebird 19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2
#> 58           Fiat X1-9 27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
#> 59       Porsche 914-2 26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
#> 60        Lotus Europa 30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
#> 61      Ford Pantera L 15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
#> 62        Ferrari Dino 19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
#> 63       Maserati Bora 15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8
#> 64          Volvo 142E 21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2
#> 65           Mazda RX4 21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
#> 66       Mazda RX4 Wag 21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
#> 67          Datsun 710 22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
#> 68      Hornet 4 Drive 21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
#> 69   Hornet Sportabout 18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
#> 70             Valiant 18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
#> 71          Duster 360 14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
#> 72           Merc 240D 24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
#> 73            Merc 230 22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
#> 74            Merc 280 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
#> 75           Merc 280C 17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
#> 76          Merc 450SE 16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
#> 77          Merc 450SL 17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
#> 78         Merc 450SLC 15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
#> 79  Cadillac Fleetwood 10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
#> 80 Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
#> 81   Chrysler Imperial 14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
#> 82            Fiat 128 32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
#> 83         Honda Civic 30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
#> 84      Toyota Corolla 33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
#> 85       Toyota Corona 21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
#> 86    Dodge Challenger 15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2
#> 87         AMC Javelin 15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2
#> 88          Camaro Z28 13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
#> 89    Pontiac Firebird 19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2
#> 90           Fiat X1-9 27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
#> 91       Porsche 914-2 26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
#> 92        Lotus Europa 30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
#> 93      Ford Pantera L 15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
#> 94        Ferrari Dino 19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
#> 95       Maserati Bora 15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8
#> 96          Volvo 142E 21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2
#>    new_var
#> 1     <NA>
#> 2     <NA>
#> 3     <NA>
#> 4     <NA>
#> 5     <NA>
#> 6     <NA>
#> 7     <NA>
#> 8     <NA>
#> 9     <NA>
#> 10    <NA>
#> 11    <NA>
#> 12    <NA>
#> 13    <NA>
#> 14    <NA>
#> 15    <NA>
#> 16    <NA>
#> 17    <NA>
#> 18    <NA>
#> 19    <NA>
#> 20    <NA>
#> 21    <NA>
#> 22    <NA>
#> 23    <NA>
#> 24    <NA>
#> 25    <NA>
#> 26    <NA>
#> 27    <NA>
#> 28    <NA>
#> 29    <NA>
#> 30    <NA>
#> 31    <NA>
#> 32    <NA>
#> 33    <NA>
#> 34    <NA>
#> 35    <NA>
#> 36    <NA>
#> 37    <NA>
#> 38    <NA>
#> 39    <NA>
#> 40    <NA>
#> 41    <NA>
#> 42    <NA>
#> 43    <NA>
#> 44    <NA>
#> 45    <NA>
#> 46    <NA>
#> 47    <NA>
#> 48    <NA>
#> 49    <NA>
#> 50    <NA>
#> 51    <NA>
#> 52    <NA>
#> 53    <NA>
#> 54    <NA>
#> 55    <NA>
#> 56    <NA>
#> 57    <NA>
#> 58    <NA>
#> 59    <NA>
#> 60    <NA>
#> 61    <NA>
#> 62    <NA>
#> 63    <NA>
#> 64    <NA>
#> 65       c
#> 66       d
#> 67       z
#> 68       b
#> 69       s
#> 70       c
#> 71       z
#> 72       y
#> 73       k
#> 74       c
#> 75       n
#> 76       j
#> 77       i
#> 78       y
#> 79       j
#> 80       y
#> 81       b
#> 82       j
#> 83       q
#> 84       d
#> 85       k
#> 86       a
#> 87       i
#> 88       s
#> 89       k
#> 90       h
#> 91       n
#> 92       l
#> 93       e
#> 94       z
#> 95       u
#> 96       h
```

  - **`select_cols()`**: Select columns of data frame

<!-- end list -->

``` r
## select only these columns
select_cols(d, cyl, gear, weight = wt)
#>    cyl gear weight
#> 1    6    4  2.620
#> 2    6    4  2.875
#> 3    4    4  2.320
#> 4    6    3  3.215
#> 5    8    3  3.440
#> 6    6    3  3.460
#> 7    8    3  3.570
#> 8    4    4  3.190
#> 9    4    4  3.150
#> 10   6    4  3.440
#> 11   6    4  3.440
#> 12   8    3  4.070
#> 13   8    3  3.730
#> 14   8    3  3.780
#> 15   8    3  5.250
#> 16   8    3  5.424
#> 17   8    3  5.345
#> 18   4    4  2.200
#> 19   4    4  1.615
#> 20   4    4  1.835
#> 21   4    3  2.465
#> 22   8    3  3.520
#> 23   8    3  3.435
#> 24   8    3  3.840
#> 25   8    3  3.845
#> 26   4    4  1.935
#> 27   4    5  2.140
#> 28   4    5  1.513
#> 29   8    5  3.170
#> 30   6    5  2.770
#> 31   8    5  3.570
#> 32   4    4  2.780
```
