# Matching continuously measured fluxes with measurement IDs and meta data

Matching a dataframe of continuously measured gas concentration data
with measurement metadata from another dataframe. Measurements are
paired with their metadata based on datetime. Extra variables in both
dataframes are kept in the output.

## Usage

``` r
flux_match(
  raw_conc,
  field_record,
  f_datetime,
  start_col,
  end_col,
  measurement_length,
  fixed_length = deprecated(),
  time_diff = 0,
  startcrop = 0,
  ratio_threshold = deprecated(),
  f_conc = deprecated()
)
```

## Arguments

- raw_conc:

  dataframe of CO2 concentration measured continuously. Has to contain
  at least a datetime column in ymd_hms format and a gas concentration
  column as double.

- field_record:

  dataframe recording which measurement happened when. Has to contain at
  least a column containing the start of each measurement, and any other
  column identifying the measurements.

- f_datetime:

  datetime column in raw_conc (`ymd_hms` format)

- start_col:

  start column in field_record (`ymd_hms` format)

- end_col:

  end column in field_record (`ymd_hms` format), if present (see
  `measurement_length`).

- measurement_length:

  length of the measurements (in seconds) from the start specified in
  the `field_record`. Use `measurement_length` if all the measurements
  have the same length and no end column is present in `field_record`.

- fixed_length:

  **\[deprecated\]** no longer required. `flux_match` will detect if
  `end_col` or `measurement_length` are provided.

- time_diff:

  time difference (in seconds) between the two datasets. Will be added
  to the datetime column of the `raw_conc` dataset. For situations where
  the time was not synchronized correctly.

- startcrop:

  **\[deprecated\]** `startcrop` is no longer supported. Please use
  `start_cut` in `flux_fitting` instead.

- ratio_threshold:

  **\[deprecated\]** `ratio_threshold` is no longer supported. Please
  use `ratio_threshold` in `flux_quality` instead.

- f_conc:

  **\[deprecated\]** `f_conc` is no longer required

## Value

a dataframe with concentration measurements, corresponding datetime,
flux ID (`f_fluxid`), measurements start (`f_start`) and end (`f_end`).

## Details

If both `end_col` and `measurement_length` are provided, `end_col` will
be ignored. Measurements either all have the same length (provide
`measurement_length`), or the length varies and `end_col` has to be
provided.

## Examples

``` r
data(co2_df_short, record_short)
flux_match(co2_df_short, record_short, datetime, start,
measurement_length = 180)
#> # A tibble: 1,080 × 11
#>    datetime            temp_air temp_soil  conc   PAR turfID       type 
#>    <dttm>                 <dbl>     <dbl> <dbl> <dbl> <chr>        <chr>
#>  1 2022-07-28 23:43:25    NA         NA    439. NA    156 AN2C 156 ER   
#>  2 2022-07-28 23:43:26     7.21      10.9  440.  2.29 156 AN2C 156 ER   
#>  3 2022-07-28 23:43:27    NA         NA    441. NA    156 AN2C 156 ER   
#>  4 2022-07-28 23:43:28    NA         NA    441. NA    156 AN2C 156 ER   
#>  5 2022-07-28 23:43:29    NA         NA    442. NA    156 AN2C 156 ER   
#>  6 2022-07-28 23:43:30    NA         NA    443. NA    156 AN2C 156 ER   
#>  7 2022-07-28 23:43:31    NA         NA    443. NA    156 AN2C 156 ER   
#>  8 2022-07-28 23:43:32    NA         NA    444. NA    156 AN2C 156 ER   
#>  9 2022-07-28 23:43:33    NA         NA    446. NA    156 AN2C 156 ER   
#> 10 2022-07-28 23:43:34    NA         NA    446. NA    156 AN2C 156 ER   
#> # ℹ 1,070 more rows
#> # ℹ 4 more variables: start <dttm>, f_start <dttm>, f_fluxid <fct>,
#> #   f_end <dttm>
```
