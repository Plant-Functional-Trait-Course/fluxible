# Using a fixed measurement length to slice the measurements

Provides the `f_end` column for `flux_match`

## Usage

``` r
flux_match_fixed(field_record, start_col, measurement_length)
```

## Arguments

- field_record:

  dataframe recording which measurement happened when. Has to contain at
  least a column containing the start of each measurement, and any other
  column identifying the measurements.

- start_col:

  start column in field_record (`ymd_hms` format)

- measurement_length:

  length of the measurement (in seconds) from the start specified in the
  `field_record`
